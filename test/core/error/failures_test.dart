import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/core/error/failures.dart';

void main() {
  group('LocalDatabaseFailure', () {
    test('should have default message', () {
      const failure = LocalDatabaseFailure();

      expect(failure.message, 'Local Database Failure');
    });

    test('should accept custom message', () {
      const failure = LocalDatabaseFailure(message: 'Custom DB error');

      expect(failure.message, 'Custom DB error');
    });

    test('should be equal when messages are the same', () {
      const failure1 = LocalDatabaseFailure();
      const failure2 = LocalDatabaseFailure();

      expect(failure1, equals(failure2));
    });

    test('should not be equal when messages differ', () {
      const failure1 = LocalDatabaseFailure();
      const failure2 = LocalDatabaseFailure(message: 'Different error');

      expect(failure1, isNot(equals(failure2)));
    });
  });

  group('ApiFailure', () {
    test('should have default message', () {
      const failure = ApiFailure();

      expect(failure.message, 'API Failure');
      expect(failure.statusCode, isNull);
    });

    test('should accept custom message', () {
      const failure = ApiFailure(message: 'Not found');

      expect(failure.message, 'Not found');
    });

    test('should accept statusCode', () {
      const failure = ApiFailure(message: 'Not found', statusCode: 404);

      expect(failure.message, 'Not found');
      expect(failure.statusCode, 404);
    });

    test('should be equal when messages are the same', () {
      const failure1 = ApiFailure();
      const failure2 = ApiFailure();

      expect(failure1, equals(failure2));
    });

    group('fromDioException', () {
      test('should return correct message for connectionTimeout', () {
        final dioException = DioException(
          type: DioExceptionType.connectionTimeout,
          requestOptions: RequestOptions(path: '/test'),
        );

        final failure = ApiFailure.fromDioException(dioException);

        expect(failure.message,
            'Connection timed out. Is the server running?');
        expect(failure.statusCode, isNull);
      });

      test('should return correct message for sendTimeout', () {
        final dioException = DioException(
          type: DioExceptionType.sendTimeout,
          requestOptions: RequestOptions(path: '/test'),
        );

        final failure = ApiFailure.fromDioException(dioException);

        expect(failure.message, 'Request timed out. Please try again.');
      });

      test('should return correct message for receiveTimeout', () {
        final dioException = DioException(
          type: DioExceptionType.receiveTimeout,
          requestOptions: RequestOptions(path: '/test'),
        );

        final failure = ApiFailure.fromDioException(dioException);

        expect(failure.message,
            'Server took too long to respond. Please try again.');
      });

      test('should return correct message for connectionError', () {
        final dioException = DioException(
          type: DioExceptionType.connectionError,
          requestOptions: RequestOptions(path: '/test'),
        );

        final failure = ApiFailure.fromDioException(dioException);

        expect(failure.message,
            'Cannot connect to server. Please make sure the backend is running.');
      });

      test('should return correct message for cancel', () {
        final dioException = DioException(
          type: DioExceptionType.cancel,
          requestOptions: RequestOptions(path: '/test'),
        );

        final failure = ApiFailure.fromDioException(dioException);

        expect(failure.message, 'Request was cancelled.');
      });

      test('should extract server message from response data', () {
        final dioException = DioException(
          type: DioExceptionType.badResponse,
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: 400,
            data: {'message': 'Invalid credentials'},
          ),
        );

        final failure = ApiFailure.fromDioException(dioException);

        expect(failure.message, 'Invalid credentials');
        expect(failure.statusCode, 400);
      });

      test(
          'should use fallback message when response has no message field', () {
        final dioException = DioException(
          type: DioExceptionType.badResponse,
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: 500,
            data: {'error': 'Internal server error'},
          ),
        );

        final failure = ApiFailure.fromDioException(dioException);

        expect(failure.message, 'Something went wrong');
        expect(failure.statusCode, 500);
      });

      test('should use custom fallback message', () {
        final dioException = DioException(
          type: DioExceptionType.badResponse,
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: 500,
            data: {'error': 'Internal server error'},
          ),
        );

        final failure = ApiFailure.fromDioException(
          dioException,
          fallback: 'Custom fallback',
        );

        expect(failure.message, 'Custom fallback');
        expect(failure.statusCode, 500);
      });

      test('should use fallback for unknown DioExceptionType', () {
        final dioException = DioException(
          type: DioExceptionType.unknown,
          requestOptions: RequestOptions(path: '/test'),
        );

        final failure = ApiFailure.fromDioException(dioException);

        expect(failure.message, 'Something went wrong');
      });
    });
  });

  group('NetworkFailure', () {
    test('should have default message', () {
      const failure = NetworkFailure();

      expect(failure.message, 'No internet connection');
    });

    test('should accept custom message', () {
      const failure = NetworkFailure(message: 'Network unavailable');

      expect(failure.message, 'Network unavailable');
    });

    test('should be equal when messages are the same', () {
      const failure1 = NetworkFailure();
      const failure2 = NetworkFailure();

      expect(failure1, equals(failure2));
    });

    test('should not be equal when messages differ', () {
      const failure1 = NetworkFailure();
      const failure2 = NetworkFailure(message: 'Custom message');

      expect(failure1, isNot(equals(failure2)));
    });
  });
}
