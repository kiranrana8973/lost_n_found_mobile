import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/core/services/connectivity/network_info.dart';
import 'package:lost_n_found/features/auth/data/datasources/auth_datasource.dart';
import 'package:lost_n_found/features/auth/data/models/auth_api_model.dart';
import 'package:lost_n_found/features/auth/data/models/auth_hive_model.dart';
import 'package:lost_n_found/features/auth/data/repositories/auth_repository.dart';
import 'package:lost_n_found/features/auth/domain/entities/auth_entity.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthLocalDatasource extends Mock implements IAuthLocalDataSource {}

class MockAuthRemoteDatasource extends Mock implements IAuthRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late AuthRepository repository;
  late MockAuthLocalDatasource mockLocalDatasource;
  late MockAuthRemoteDatasource mockRemoteDatasource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockLocalDatasource = MockAuthLocalDatasource();
    mockRemoteDatasource = MockAuthRemoteDatasource();
    mockNetworkInfo = MockNetworkInfo();
    repository = AuthRepository(
      authDatasource: mockLocalDatasource,
      authRemoteDataSource: mockRemoteDatasource,
      networkInfo: mockNetworkInfo,
    );
  });

  setUpAll(() {
    registerFallbackValue(
      AuthApiModel(
        fullName: 'Test',
        email: 'test@example.com',
        username: 'testuser',
      ),
    );
    registerFallbackValue(
      AuthHiveModel(
        fullName: 'Test',
        email: 'test@example.com',
        username: 'testuser',
      ),
    );
  });

  const tAuthEntity = AuthEntity(
    authId: '1',
    fullName: 'Test User',
    email: 'test@example.com',
    username: 'testuser',
    password: 'password123',
  );

  final tAuthApiModel = AuthApiModel(
    id: '1',
    fullName: 'Test User',
    email: 'test@example.com',
    username: 'testuser',
  );

  final tAuthHiveModel = AuthHiveModel(
    authId: '1',
    fullName: 'Test User',
    email: 'test@example.com',
    username: 'testuser',
    password: 'password123',
  );

  group('register', () {
    test(
      'should return Right(true) when online and remote call succeeds',
      () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => mockRemoteDatasource.register(any()),
        ).thenAnswer((_) async => tAuthApiModel);

        // Act
        final result = await repository.register(tAuthEntity);

        // Assert
        expect(result, const Right(true));
        verify(() => mockRemoteDatasource.register(any())).called(1);
      },
    );

    test(
      'should return Left(ApiFailure) when online and DioException occurs',
      () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemoteDatasource.register(any())).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/register'),
            response: Response(
              requestOptions: RequestOptions(path: '/register'),
              statusCode: 400,
              data: {'message': 'Registration failed'},
            ),
          ),
        );

        // Act
        final result = await repository.register(tAuthEntity);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<ApiFailure>()),
          (_) => fail('Should return failure'),
        );
      },
    );

    test(
      'should register locally when offline and email does not exist',
      () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        when(
          () => mockLocalDatasource.getUserByEmail(any()),
        ).thenAnswer((_) async => null);
        when(
          () => mockLocalDatasource.register(any()),
        ).thenAnswer((_) async => tAuthHiveModel);

        // Act
        final result = await repository.register(tAuthEntity);

        // Assert
        expect(result, const Right(true));
        verify(() => mockLocalDatasource.register(any())).called(1);
        verifyNever(() => mockRemoteDatasource.register(any()));
      },
    );

    test(
      'should return Left(LocalDatabaseFailure) when offline and email exists',
      () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        when(
          () => mockLocalDatasource.getUserByEmail(any()),
        ).thenAnswer((_) async => tAuthHiveModel);

        // Act
        final result = await repository.register(tAuthEntity);

        // Assert
        expect(result.isLeft(), true);
        result.fold((failure) {
          expect(failure, isA<LocalDatabaseFailure>());
          expect(
            (failure as LocalDatabaseFailure).message,
            'Email already registered',
          );
        }, (_) => fail('Should return failure'));
      },
    );
  });

  group('login', () {
    const tEmail = 'test@example.com';
    const tPassword = 'password123';

    test('should return AuthEntity when online and login succeeds', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => mockRemoteDatasource.login(tEmail, tPassword),
      ).thenAnswer((_) async => tAuthApiModel);

      // Act
      final result = await repository.login(tEmail, tPassword);

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should return entity'),
        (entity) => expect(entity.email, tEmail),
      );
    });

    test(
      'should return Left(ApiFailure) when online and credentials invalid',
      () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => mockRemoteDatasource.login(tEmail, tPassword),
        ).thenAnswer((_) async => null);

        // Act
        final result = await repository.login(tEmail, tPassword);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<ApiFailure>()),
          (_) => fail('Should return failure'),
        );
      },
    );

    test(
      'should return Left(ApiFailure) when online and DioException occurs',
      () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemoteDatasource.login(tEmail, tPassword)).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/login'),
            response: Response(
              requestOptions: RequestOptions(path: '/login'),
              statusCode: 401,
              data: {'message': 'Invalid credentials'},
            ),
          ),
        );

        // Act
        final result = await repository.login(tEmail, tPassword);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<ApiFailure>()),
          (_) => fail('Should return failure'),
        );
      },
    );

    test(
      'should return AuthEntity when offline and local login succeeds',
      () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        when(
          () => mockLocalDatasource.login(tEmail, tPassword),
        ).thenAnswer((_) async => tAuthHiveModel);

        // Act
        final result = await repository.login(tEmail, tPassword);

        // Assert
        expect(result.isRight(), true);
        verifyNever(() => mockRemoteDatasource.login(any(), any()));
      },
    );

    test(
      'should return Left(LocalDatabaseFailure) when offline and credentials invalid',
      () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        when(
          () => mockLocalDatasource.login(tEmail, tPassword),
        ).thenAnswer((_) async => null);

        // Act
        final result = await repository.login(tEmail, tPassword);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<LocalDatabaseFailure>()),
          (_) => fail('Should return failure'),
        );
      },
    );
  });

  group('getCurrentUser', () {
    test('should return AuthEntity when user is logged in', () async {
      // Arrange
      when(
        () => mockLocalDatasource.getCurrentUser(),
      ).thenAnswer((_) async => tAuthHiveModel);

      // Act
      final result = await repository.getCurrentUser();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should return entity'),
        (entity) => expect(entity.email, tAuthEntity.email),
      );
    });

    test(
      'should return Left(LocalDatabaseFailure) when no user logged in',
      () async {
        // Arrange
        when(
          () => mockLocalDatasource.getCurrentUser(),
        ).thenAnswer((_) async => null);

        // Act
        final result = await repository.getCurrentUser();

        // Assert
        expect(result.isLeft(), true);
        result.fold((failure) {
          expect(failure, isA<LocalDatabaseFailure>());
          expect(
            (failure as LocalDatabaseFailure).message,
            'No user logged in',
          );
        }, (_) => fail('Should return failure'));
      },
    );

    test(
      'should return Left(LocalDatabaseFailure) when exception occurs',
      () async {
        // Arrange
        when(
          () => mockLocalDatasource.getCurrentUser(),
        ).thenThrow(Exception('Database error'));

        // Act
        final result = await repository.getCurrentUser();

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<LocalDatabaseFailure>()),
          (_) => fail('Should return failure'),
        );
      },
    );
  });

  group('logout', () {
    test('should return Right(true) when logout succeeds', () async {
      // Arrange
      when(() => mockLocalDatasource.logout()).thenAnswer((_) async => true);

      // Act
      final result = await repository.logout();

      // Assert
      expect(result, const Right(true));
      verify(() => mockLocalDatasource.logout()).called(1);
    });

    test(
      'should return Left(LocalDatabaseFailure) when logout fails',
      () async {
        // Arrange
        when(() => mockLocalDatasource.logout()).thenAnswer((_) async => false);

        // Act
        final result = await repository.logout();

        // Assert
        expect(result.isLeft(), true);
        result.fold((failure) {
          expect(failure, isA<LocalDatabaseFailure>());
          expect((failure as LocalDatabaseFailure).message, 'Failed to logout');
        }, (_) => fail('Should return failure'));
      },
    );

    test(
      'should return Left(LocalDatabaseFailure) when exception occurs',
      () async {
        // Arrange
        when(
          () => mockLocalDatasource.logout(),
        ).thenThrow(Exception('Logout error'));

        // Act
        final result = await repository.logout();

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<LocalDatabaseFailure>()),
          (_) => fail('Should return failure'),
        );
      },
    );
  });
}
