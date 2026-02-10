class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException({
    required this.message,
    this.statusCode,
  });
}

class CacheException implements Exception {
  final String message;

  CacheException(this.message);
}

class NetworkException implements Exception {
  final String message;

  NetworkException(this.message);
}

class UnauthorizedException implements Exception {
  final String message;

  UnauthorizedException(this.message);
}

class NotFoundException implements Exception {
  final String message;

  NotFoundException(this.message);
}

class ForbiddenException implements Exception {
  final String message;

  ForbiddenException({required this.message});
}

class ValidationException implements Exception {
  final String message;
  final dynamic errors;

  ValidationException({required this.message, this.errors});
}
