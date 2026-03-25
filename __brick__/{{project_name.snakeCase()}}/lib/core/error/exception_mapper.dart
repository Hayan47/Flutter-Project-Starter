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
/// Extracts error messages from API responses when available.
Failure _mapDioException(DioException e, {String? notFoundMessage}) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return NetworkFailure(
        _extractErrorMessage(e.response) ?? 'Connection timeout',
      );
    case DioExceptionType.connectionError:
      return NetworkFailure(
        _extractErrorMessage(e.response) ?? 'No internet connection',
      );
    case DioExceptionType.badResponse:
      final statusCode = e.response?.statusCode;
      final errorMessage = _extractErrorMessage(e.response);

      if (statusCode == 401) {
        return UnauthorizedFailure(errorMessage ?? 'Invalid credentials');
      }
      if (statusCode == 403) {
        return ForbiddenFailure(errorMessage ?? 'Access forbidden');
      }
      if (statusCode == 404) {
        return NotFoundFailure(
          notFoundMessage ?? errorMessage ?? 'Resource not found',
        );
      }
      if (statusCode == 400) {
        return ValidationFailure(errorMessage ?? 'Validation error');
      }
      return ServerFailure(errorMessage ?? 'Server error');
    default:
      return ServerFailure(
        _extractErrorMessage(e.response) ?? e.message ?? 'Unknown error occurred',
      );
  }
}

/// Extracts error message from API response.
/// Handles multiple response formats commonly used by REST APIs.
String? _extractErrorMessage(Response? response) {
  if (response?.data == null) return null;

  final data = response!.data;

  // Handle different response formats
  if (data is Map<String, dynamic>) {
    // Try common error message fields
    // Format 1: { "message": "Error message" }
    if (data['message'] != null) {
      return data['message'].toString();
    }

    // Format 2: { "error": "Error message" }
    if (data['error'] != null) {
      return data['error'].toString();
    }

    // Format 3: { "detail": "Error message" }
    if (data['detail'] != null) {
      return data['detail'].toString();
    }

    // Format 4: { "errors": ["Error 1", "Error 2"] }
    if (data['errors'] != null) {
      if (data['errors'] is List && (data['errors'] as List).isNotEmpty) {
        return (data['errors'] as List).first.toString();
      }
      if (data['errors'] is Map) {
        final errors = data['errors'] as Map;
        if (errors.isNotEmpty) {
          return errors.values.first.toString();
        }
      }
    }

    // Format 5: { "error": { "message": "Error message" } }
    if (data['error'] is Map) {
      final errorMap = data['error'] as Map<String, dynamic>;
      if (errorMap['message'] != null) {
        return errorMap['message'].toString();
      }
    }

    // Format 6: Field-level validation errors (Django/DRF style)
    // { "username": ["Username already exists"], "email": ["Email is required"] }
    final fieldErrors = _extractFieldValidationErrors(data);
    if (fieldErrors != null) {
      return fieldErrors;
    }
  }

  // Fallback: if data is a string
  if (data is String && data.isNotEmpty) {
    return data;
  }

  return null;
}

/// Extracts field-level validation errors from Django/DRF style responses.
/// Format: { "fieldName": ["Error message 1", "Error message 2"], ... }
String? _extractFieldValidationErrors(Map<String, dynamic> data) {
  // Filter out known top-level keys that aren't field errors
  final knownKeys = {'message', 'error', 'detail', 'errors', 'status', 'code'};

  for (final entry in data.entries) {
    // Skip known non-field keys
    if (knownKeys.contains(entry.key)) continue;

    final value = entry.value;

    // Handle array of errors: "username": ["Error 1", "Error 2"]
    if (value is List && value.isNotEmpty) {
      final firstError = value.first;
      return firstError.toString();
    }

    // Handle single error string: "username": "Error message"
    if (value is String && value.isNotEmpty) {
      return value;
    }
  }

  return null;
}
