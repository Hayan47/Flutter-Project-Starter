import 'package:dio/dio.dart';
import 'package:{{project_name.snakeCase()}}/core/error/exceptions.dart';
import 'package:{{project_name.snakeCase()}}/core/network/dio_interceptor.dart';
import 'package:{{project_name.snakeCase()}}/core/services/logger_service.dart';
import 'package:{{project_name.snakeCase()}}/config/env_config.dart';
import 'package:{{project_name.snakeCase()}}/shared/constants/app_constants.dart';
import 'package:injectable/injectable.dart';
{{#use_jwt_auth}}
import 'package:{{project_name.snakeCase()}}/core/storage/secure_storage_service.dart';
import 'package:synchronized/synchronized.dart';
{{/use_jwt_auth}}

@lazySingleton
class ApiClient {
  late final Dio _dio;
  final LoggerService _logger;
{{#use_jwt_auth}}
  final SecureStorageService _secureStorage;
  final _refreshLock = Lock();
{{/use_jwt_auth}}

{{#use_jwt_auth}}
  ApiClient({
    required LoggerService logger,
    required SecureStorageService secureStorage,
  }) : _logger = logger,
       _secureStorage = secureStorage {
{{/use_jwt_auth}}
{{^use_jwt_auth}}
  ApiClient({
    required LoggerService logger,
  }) : _logger = logger {
{{/use_jwt_auth}}
    _dio = Dio(
      BaseOptions(
        baseUrl: EnvConfig.baseUrl,
        connectTimeout: const Duration(seconds: AppConstants.apiTimeoutSeconds),
        receiveTimeout: const Duration(seconds: AppConstants.apiTimeoutSeconds),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.addAll([
      InterceptorsWrapper(onRequest: _onRequest, onError: _onError),
      if (EnvConfig.isDevelopment) DioInterceptor(logger: _logger),
    ]);
  }

  Dio get dio => _dio;
{{#use_jwt_auth}}

  Future<void> setAuthToken(String token) async {
    await _secureStorage.write(AppConstants.tokenKey, token);
  }

  Future<void> setRefreshToken(String token) async {
    await _secureStorage.write(AppConstants.refreshTokenKey, token);
  }

  Future<void> clearAuthToken() async {
    await _secureStorage.delete(AppConstants.tokenKey);
    await _secureStorage.delete(AppConstants.refreshTokenKey);
  }
{{/use_jwt_auth}}

  void _onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
{{#use_jwt_auth}}
    final token = await _secureStorage.read(AppConstants.tokenKey);
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
{{/use_jwt_auth}}
    handler.next(options);
  }

  Future<void> _onError(DioException e, ErrorInterceptorHandler handler) async {
{{#use_jwt_auth}}
    if (e.response?.statusCode != 401) {
      return handler.next(e);
    }

    // Prevent infinite loop when the refresh endpoint itself returns 401
    if (e.requestOptions.path.contains(AppConstants.tokenRefreshEndpoint)) {
      await clearAuthToken();
      return handler.reject(e);
    }

    await _refreshLock.synchronized(() async {
      final currentToken = await _secureStorage.read(AppConstants.tokenKey);
      final requestToken = (e.requestOptions.headers['Authorization']
              as String?)
          ?.replaceFirst('Bearer ', '');

      // Token was already refreshed by a concurrent request — just retry
      if (currentToken != null &&
          currentToken.isNotEmpty &&
          currentToken != requestToken) {
        try {
          return handler.resolve(await _retryRequest(e.requestOptions));
        } catch (_) {
          return handler.reject(e);
        }
      }

      final refreshed = await _tryRefreshToken();
      if (refreshed) {
        try {
          return handler.resolve(await _retryRequest(e.requestOptions));
        } catch (_) {}
      }

      return handler.reject(e);
    });
{{/use_jwt_auth}}
{{^use_jwt_auth}}
    handler.next(e);
{{/use_jwt_auth}}
  }
{{#use_jwt_auth}}

  Future<bool> _tryRefreshToken() async {
    try {
      final refreshToken = await_secureStorage.read(AppConstants.refreshTokenKey);
      if (refreshToken == null || refreshToken.isEmpty) return false;

      final response = await _dio.post(
        AppConstants.tokenRefreshEndpoint,
        data: {'refresh': refreshToken},
      );

      final newAccessToken = response.data['access'] as String?;
      final newRefreshToken = response.data['refresh'] as String?;

      if (newAccessToken == null) return false;

      await _secureStorage.write(AppConstants.tokenKey, newAccessToken);
      if (newRefreshToken != null) {
        await _secureStorage.write(AppConstants.refreshTokenKey, newRefreshToken);
      }
      return true;
    } catch (e) {
      _logger.error('Token refresh failed', e);
      await clearAuthToken();
      return false;
    }
  }

  Future<Response> _retryRequest(RequestOptions requestOptions) async {
    final token = await _secureStorage.read(AppConstants.tokenKey);
    return _dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: Options(
        method: requestOptions.method,
        headers: {
          ...requestOptions.headers,
          if (token != null) 'Authorization': 'Bearer $token',
        },
      ),
    );
  }
{{/use_jwt_auth}}
}