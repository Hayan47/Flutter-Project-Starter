import 'package:dio/dio.dart';
import 'package:{{project_name.snakeCase()}}/core/error/exceptions.dart';
import 'package:{{project_name.snakeCase()}}/core/network/dio_interceptor.dart';
import 'package:{{project_name.snakeCase()}}/core/services/logger_service.dart';

class ApiClient {
  late final Dio _dio;
  final LoggerService _logger;
  final String baseUrl;

  ApiClient({
    required this.baseUrl,
    required LoggerService logger,
  }) : _logger = logger {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(DioInterceptor(logger: _logger));
  }

  Dio get dio => _dio;

  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException error) {
    _logger.error('DioException occurred', error);

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException('Connection timeout. Please check your internet connection.');

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data['message'] ?? error.message ?? 'Server error';

        if (statusCode == 401) {
          return UnauthorizedException(message);
        } else if (statusCode == 404) {
          return NotFoundException(message);
        } else {
          return ServerException(
            message: message,
            statusCode: statusCode,
          );
        }

      case DioExceptionType.cancel:
        return ServerException(message: 'Request cancelled');

      case DioExceptionType.connectionError:
        return NetworkException('No internet connection');

      case DioExceptionType.badCertificate:
        return ServerException(message: 'Certificate verification failed');

      case DioExceptionType.unknown:
      default:
        return ServerException(
          message: error.message ?? 'An unexpected error occurred',
        );
    }
  }
}