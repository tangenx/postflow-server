class AppException implements Exception {
  final String message;

  AppException(this.message);

  @override
  String toString() => 'AppException: $message';

  Map<String, String> toJson() => {'status': 'error', 'message': message};
}

class UnathorizedException extends AppException {
  UnathorizedException(super.message);
}

class ConflictException extends AppException {
  ConflictException(super.message);
}

class NotFoundException extends AppException {
  NotFoundException(super.message);
}

class ValidationException extends AppException {
  ValidationException(super.message);
}
