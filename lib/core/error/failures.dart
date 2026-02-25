import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class LocalDatabaseFailure extends Failure {
  const LocalDatabaseFailure({String message = "Local Database Failure"})
    : super(message);
}

class ApiFailure extends Failure {
  final int? statusCode;

  const ApiFailure({String message = "API Failure", this.statusCode})
    : super(message);

  factory ApiFailure.fromDioException(
    DioException e, {
    String fallback = 'Something went wrong',
  }) {
    if (e.response != null) {
      final data = e.response?.data;
      String? serverMessage;
      if (data is Map<String, dynamic>) {
        serverMessage = data['message'] as String?;
      }
      return ApiFailure(
        message: serverMessage ?? fallback,
        statusCode: e.response?.statusCode,
      );
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return const ApiFailure(
          message: 'Connection timed out. Is the server running?',
        );
      case DioExceptionType.sendTimeout:
        return const ApiFailure(
          message: 'Request timed out. Please try again.',
        );
      case DioExceptionType.receiveTimeout:
        return const ApiFailure(
          message: 'Server took too long to respond. Please try again.',
        );
      case DioExceptionType.connectionError:
        return const ApiFailure(
          message:
              'Cannot connect to server. Please make sure the backend is running.',
        );
      case DioExceptionType.cancel:
        return const ApiFailure(message: 'Request was cancelled.');
      default:
        return ApiFailure(message: fallback);
    }
  }
}

class NetworkFailure extends Failure {
  const NetworkFailure({String message = "No internet connection"})
    : super(message);
}
