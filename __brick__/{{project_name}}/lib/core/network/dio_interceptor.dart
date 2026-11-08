import 'package:dio/dio.dart';
import 'package:{{project_name.snakeCase()}}/core/services/logger_service.dart';

class DioInterceptor extends Interceptor {
  final LoggerService logger;

  DioInterceptor({required this.logger});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    logger.logApiRequest(
      options.method,
      options.uri.toString(),
      options.data,
    );
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.logApiResponse(
      response.requestOptions.method,
      response.requestOptions.uri.toString(),
      response.statusCode ?? 0,
      response.data,
    );
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    logger.logApiError(
      err.requestOptions.method,
      err.requestOptions.uri.toString(),
      err,
    );
    super.onError(err, handler);
  }
}