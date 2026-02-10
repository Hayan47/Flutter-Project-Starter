import 'package:dio/dio.dart';

import 'exceptions.dart';
import 'failures.dart';

/// Maps any exception from data layer to domain Failure.
/// This is the boundary layer that knows about infrastructure (Dio, storage, etc.)
/// and converts infrastructure exceptions to domain failures.
Failure mapToFailure(dynamic error, {String? notFoundMessage}) {
  // Handle app-specific exceptions (thrown by datasources)
  if (error is NetworkException) return NetworkFailure(error.message);
  if (error is ServerException) return ServerFailure(error.message);
  if (error is CacheException) return CacheFailure(error.message);
  if (error is UnauthorizedException) return UnauthorizedFailure(error.message);
  if (error is NotFoundException) {
    return NotFoundFailure(notFoundMessage ?? error.message);
  }
  if (error is ForbiddenException) return ForbiddenFailure(error.message);
  if (error is ValidationException) return ValidationFailure(error.message);

  // Handle infrastructure exceptions (Retrofit/Dio leakage)
  if (error is DioException) {
    return _mapDioException(error, notFoundMessage: notFoundMessage);
  }

  // Handle storage exceptions (future extensibility)
  // if (error is HiveError) return CacheFailure(error.toString());

  // Fallback for unknown errors
  return ServerFailure(error.toString());
}

/// Internal mapper for DioException to Failure.
/// Handles network-level errors and HTTP status codes.
Failure _mapDioException(DioException e, {String? notFoundMessage}) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return const NetworkFailure('Connection timeout');
    case DioExceptionType.connectionError:
      return const NetworkFailure('No internet connection');
    case DioExceptionType.badResponse:
      final statusCode = e.response?.statusCode;
      if (statusCode == 401) {
        return const UnauthorizedFailure('Invalid credentials');
      }
      if (statusCode == 403) return const ForbiddenFailure();
      if (statusCode == 404) {
        return NotFoundFailure(notFoundMessage ?? 'Resource not found');
      }
      return ServerFailure(
        e.response?.data?['message']?.toString() ?? 'Server error',
      );
    default:
      return ServerFailure(e.message ?? 'Unknown error occurred');
  }
}