import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/features/auth/data/models/auth_api_model.dart';
import 'package:lost_n_found/features/auth/data/models/auth_hive_model.dart';
import 'package:lost_n_found/features/auth/data/repositories/auth_repository.dart';
import 'package:lost_n_found/features/auth/domain/entities/auth_entity.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/test_mocks.dart';

class FakeAuthApiModel extends Fake implements AuthApiModel {}

class FakeAuthHiveModel extends Fake implements AuthHiveModel {}

void main() {
  late AuthRepository repository;
  late MockAuthLocalDataSource mockLocalDataSource;
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUpAll(() {
    registerFallbackValue(FakeAuthApiModel());
    registerFallbackValue(FakeAuthHiveModel());
  });

  setUp(() {
    mockLocalDataSource = MockAuthLocalDataSource();
    mockRemoteDataSource = MockAuthRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = AuthRepository(
      authDatasource: mockLocalDataSource,
      authRemoteDataSource: mockRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  const tAuthEntity = AuthEntity(
    authId: '1',
    fullName: 'Test User',
    email: 'test@test.com',
    phoneNumber: '123',
    username: 'testuser',
    password: 'password123',
    batchId: null,
    profilePicture: null,
  );

  final tAuthApiModel = AuthApiModel(
    id: '1',
    fullName: 'Test User',
    email: 'test@test.com',
    phoneNumber: '123',
    username: 'testuser',
    password: 'password123',
    batchId: null,
    profilePicture: null,
  );

  final tAuthHiveModel = AuthHiveModel(
    authId: '1',
    fullName: 'Test User',
    email: 'test@test.com',
    phoneNumber: '123',
    username: 'testuser',
    password: 'password123',
    batchId: null,
    profilePicture: null,
  );

  group('register', () {
    test(
      'should return Right(true) when online and registration succeeds',
      () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => mockRemoteDataSource.register(any()),
        ).thenAnswer((_) async => tAuthApiModel);

        final result = await repository.register(tAuthEntity);

        expect(result, const Right(true));
        verify(() => mockRemoteDataSource.register(any())).called(1);
      },
    );

    test(
      'should return Left(ApiFailure) when online and DioException is thrown',
      () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemoteDataSource.register(any())).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/test'),
            type: DioExceptionType.connectionTimeout,
          ),
        );

        final result = await repository.register(tAuthEntity);

        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<ApiFailure>()),
          (_) => fail('Should be Left'),
        );
      },
    );

    test(
      'should return Right(true) when offline and registration succeeds locally',
      () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        when(
          () => mockLocalDataSource.getUserByEmail(any()),
        ).thenAnswer((_) async => null);
        when(
          () => mockLocalDataSource.register(any()),
        ).thenAnswer((_) async => tAuthHiveModel);

        final result = await repository.register(tAuthEntity);

        expect(result, const Right(true));
        verify(() => mockLocalDataSource.register(any())).called(1);
      },
    );

    test(
      'should return Left(LocalDatabaseFailure) when offline and email already exists',
      () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        when(
          () => mockLocalDataSource.getUserByEmail(any()),
        ).thenAnswer((_) async => tAuthHiveModel);

        final result = await repository.register(tAuthEntity);

        expect(result.isLeft(), true);
        result.fold((failure) {
          expect(failure, isA<LocalDatabaseFailure>());
          expect(failure.message, 'Email already registered');
        }, (_) => fail('Should be Left'));
        verifyNever(() => mockLocalDataSource.register(any()));
      },
    );
  });

  group('login', () {
    const tEmail = 'test@test.com';
    const tPassword = 'password123';

    test(
      'should return Right(AuthEntity) when online and login succeeds',
      () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => mockRemoteDataSource.login(any(), any()),
        ).thenAnswer((_) async => tAuthApiModel);
        when(
          () => mockLocalDataSource.register(any()),
        ).thenAnswer((_) async => tAuthHiveModel);

        final result = await repository.login(tEmail, tPassword);

        expect(result.isRight(), true);
        result.fold(
          (_) => fail('Should be Right'),
          (entity) => expect(entity, isA<AuthEntity>()),
        );
        verify(() => mockLocalDataSource.register(any())).called(1);
      },
    );

    test(
      'should return Left(ApiFailure) when online and DioException is thrown',
      () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemoteDataSource.login(any(), any())).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/test'),
            type: DioExceptionType.connectionTimeout,
          ),
        );

        final result = await repository.login(tEmail, tPassword);

        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<ApiFailure>()),
          (_) => fail('Should be Left'),
        );
      },
    );

    test(
      'should return Right(AuthEntity) when offline and local login succeeds',
      () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        when(
          () => mockLocalDataSource.login(any(), any()),
        ).thenAnswer((_) async => tAuthHiveModel);

        final result = await repository.login(tEmail, tPassword);

        expect(result.isRight(), true);
        result.fold(
          (_) => fail('Should be Right'),
          (entity) => expect(entity, isA<AuthEntity>()),
        );
      },
    );

    test(
      'should return Left(LocalDatabaseFailure) when offline and local login fails',
      () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        when(
          () => mockLocalDataSource.login(any(), any()),
        ).thenAnswer((_) async => null);

        final result = await repository.login(tEmail, tPassword);

        expect(result.isLeft(), true);
        result.fold((failure) {
          expect(failure, isA<LocalDatabaseFailure>());
          expect(failure.message, 'Invalid email or password');
        }, (_) => fail('Should be Left'));
      },
    );
  });

  group('getCurrentUser', () {
    test(
      'should return Right(AuthEntity) from remote when online and API succeeds',
      () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => mockRemoteDataSource.getCurrentUser(),
        ).thenAnswer((_) async => tAuthApiModel);
        when(
          () => mockLocalDataSource.updateUser(any()),
        ).thenAnswer((_) async => true);

        final result = await repository.getCurrentUser();

        expect(result.isRight(), true);
        result.fold(
          (_) => fail('Should be Right'),
          (entity) => expect(entity, isA<AuthEntity>()),
        );
        verify(() => mockRemoteDataSource.getCurrentUser()).called(1);
        verify(() => mockLocalDataSource.updateUser(any())).called(1);
      },
    );

    test(
      'should fallback to local when online but API throws DioException',
      () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemoteDataSource.getCurrentUser()).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/test'),
            type: DioExceptionType.connectionTimeout,
          ),
        );
        when(
          () => mockLocalDataSource.getCurrentUser(),
        ).thenAnswer((_) async => tAuthHiveModel);

        final result = await repository.getCurrentUser();

        expect(result.isRight(), true);
        result.fold(
          (_) => fail('Should be Right'),
          (entity) => expect(entity, isA<AuthEntity>()),
        );
      },
    );

    test('should return Right(AuthEntity) from local when offline', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(
        () => mockLocalDataSource.getCurrentUser(),
      ).thenAnswer((_) async => tAuthHiveModel);

      final result = await repository.getCurrentUser();

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should be Right'),
        (entity) => expect(entity, isA<AuthEntity>()),
      );
      verifyNever(() => mockRemoteDataSource.getCurrentUser());
    });

    test(
      'should return Left(LocalDatabaseFailure) when offline and no local user',
      () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        when(
          () => mockLocalDataSource.getCurrentUser(),
        ).thenAnswer((_) async => null);

        final result = await repository.getCurrentUser();

        expect(result.isLeft(), true);
        result.fold((failure) {
          expect(failure, isA<LocalDatabaseFailure>());
          expect(failure.message, 'No user logged in');
        }, (_) => fail('Should be Left'));
      },
    );
  });

  group('logout', () {
    test('should return Right(true) when logout succeeds', () async {
      when(() => mockLocalDataSource.logout()).thenAnswer((_) async => true);

      final result = await repository.logout();

      expect(result, const Right(true));
    });

    test(
      'should return Left(LocalDatabaseFailure) when logout fails',
      () async {
        when(() => mockLocalDataSource.logout()).thenAnswer((_) async => false);

        final result = await repository.logout();

        expect(result.isLeft(), true);
        result.fold((failure) {
          expect(failure, isA<LocalDatabaseFailure>());
          expect(failure.message, 'Failed to logout');
        }, (_) => fail('Should be Left'));
      },
    );
  });
}
