/// Base exception for the application
abstract class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

/// Thrown when API call fails or returns an error response
class ApiException extends AppException {
  const ApiException({String message = 'API error', int? statusCode})
    : super(message, statusCode: statusCode);
}

/// Thrown when local database (Hive) operation fails
class DatabaseException extends AppException {
  const DatabaseException({String message = 'Database error'}) : super(message);
}

/// Thrown when there is no internet connection
class NetworkException extends AppException {
  const NetworkException({String message = 'No internet connection'})
    : super(message);
}

/// Thrown when token is missing or expired
class UnauthorizedException extends AppException {
  const UnauthorizedException({String message = 'Unauthorized'})
    : super(message, statusCode: 401);
}
