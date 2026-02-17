import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/features/auth/domain/entities/auth_entity.dart';
import 'package:lost_n_found/features/auth/domain/repositories/auth_repository.dart';
import 'package:lost_n_found/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:lost_n_found/features/auth/domain/usecases/login_usecase.dart';
import 'package:lost_n_found/features/auth/domain/usecases/logout_usecase.dart';
import 'package:lost_n_found/features/auth/domain/usecases/register_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late MockAuthRepository mockRepo;

  const tUser = AuthEntity(
    authId: 'user-1',
    fullName: 'Test User',
    email: 'test@test.com',
    username: 'testuser',
  );

  setUp(() {
    mockRepo = MockAuthRepository();
  });

  setUpAll(() {
    registerFallbackValue(tUser);
  });

  group('RegisterUsecase', () {
    late RegisterUsecase usecase;

    setUp(() {
      usecase = RegisterUsecase(authRepository: mockRepo);
    });

    const tParams = RegisterParams(
      fullName: 'Test User',
      email: 'test@test.com',
      username: 'testuser',
      password: 'password123',
      batchId: 'batch-1',
    );

    test('should call repository.register with correct AuthEntity', () async {
      when(() => mockRepo.register(any()))
          .thenAnswer((_) async => const Right(true));

      final result = await usecase(tParams);

      expect(result, const Right(true));
      verify(() => mockRepo.register(any())).called(1);
    });

    test('should return failure when repository fails', () async {
      when(() => mockRepo.register(any()))
          .thenAnswer((_) async => const Left(ApiFailure(message: 'Email taken')));

      final result = await usecase(tParams);

      expect(result, const Left(ApiFailure(message: 'Email taken')));
    });
  });

  group('LoginUsecase', () {
    late LoginUsecase usecase;

    setUp(() {
      usecase = LoginUsecase(authRepository: mockRepo);
    });

    const tParams = LoginParams(email: 'test@test.com', password: 'password123');

    test('should call repository.login with email and password', () async {
      when(() => mockRepo.login(any(), any()))
          .thenAnswer((_) async => const Right(tUser));

      final result = await usecase(tParams);

      expect(result, const Right(tUser));
      verify(() => mockRepo.login('test@test.com', 'password123')).called(1);
    });

    test('should return failure on invalid credentials', () async {
      when(() => mockRepo.login(any(), any()))
          .thenAnswer((_) async => const Left(ApiFailure(message: 'Invalid credentials')));

      final result = await usecase(tParams);

      expect(result, const Left(ApiFailure(message: 'Invalid credentials')));
    });
  });

  group('GetCurrentUserUsecase', () {
    late GetCurrentUserUsecase usecase;

    setUp(() {
      usecase = GetCurrentUserUsecase(authRepository: mockRepo);
    });

    test('should return current user from repository', () async {
      when(() => mockRepo.getCurrentUser())
          .thenAnswer((_) async => const Right(tUser));

      final result = await usecase();

      expect(result, const Right(tUser));
      verify(() => mockRepo.getCurrentUser()).called(1);
    });

    test('should return failure when not authenticated', () async {
      when(() => mockRepo.getCurrentUser())
          .thenAnswer((_) async => const Left(ApiFailure(message: 'Not logged in')));

      final result = await usecase();

      expect(result, const Left(ApiFailure(message: 'Not logged in')));
    });
  });

  group('LogoutUsecase', () {
    late LogoutUsecase usecase;

    setUp(() {
      usecase = LogoutUsecase(authRepository: mockRepo);
    });

    test('should call repository.logout', () async {
      when(() => mockRepo.logout())
          .thenAnswer((_) async => const Right(true));

      final result = await usecase();

      expect(result, const Right(true));
      verify(() => mockRepo.logout()).called(1);
    });

    test('should return failure when logout fails', () async {
      when(() => mockRepo.logout())
          .thenAnswer((_) async => const Left(ApiFailure(message: 'Logout failed')));

      final result = await usecase();

      expect(result, const Left(ApiFailure(message: 'Logout failed')));
    });
  });
}
