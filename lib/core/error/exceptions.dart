abstract class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class ApiException extends AppException {
  const ApiException({String message = 'API error', int? statusCode})
    : super(message, statusCode: statusCode);
}

class DatabaseException extends AppException {
  const DatabaseException({String message = 'Database error'}) : super(message);
}

class NetworkException extends AppException {
  const NetworkException({String message = 'No internet connection'})
    : super(message);
}

class UnauthorizedException extends AppException {
  const UnauthorizedException({String message = 'Unauthorized'})
    : super(message, statusCode: 401);
}
