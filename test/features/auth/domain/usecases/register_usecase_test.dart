import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/features/auth/domain/entities/auth_entity.dart';
import 'package:lost_n_found/features/auth/domain/repositories/auth_repository.dart';
import 'package:lost_n_found/features/auth/domain/usecases/register_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late RegisterUsecase usecase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = RegisterUsecase(authRepository: mockRepository);
  });

  setUpAll(() {
    registerFallbackValue(
      const AuthEntity(
        fullName: 'fallback',
        email: 'fallback@email.com',
        username: 'fallback',
      ),
    );
  });

  const tFullName = 'Test User';
  const tEmail = 'test@example.com';
  const tUsername = 'testuser';
  const tPassword = 'password123';
  const tPhoneNumber = '1234567890';
  const tBatchId = 'batch1';

  group('RegisterUsecase', () {
    test('should return true when registration is successful', () async {
      // Arrange
      when(
        () => mockRepository.register(any()),
      ).thenAnswer((_) async => const Right(true));

      // Act
      final result = await usecase(
        const RegisterParams(
          fullName: tFullName,
          email: tEmail,
          username: tUsername,
          password: tPassword,
        ),
      );

      // Assert
      expect(result, const Right(true));
      verify(() => mockRepository.register(any())).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should pass AuthEntity with correct values to repository', () async {
      // Arrange
      AuthEntity? capturedEntity;
      when(() => mockRepository.register(any())).thenAnswer((invocation) {
        capturedEntity = invocation.positionalArguments[0] as AuthEntity;
        return Future.value(const Right(true));
      });

      // Act
      await usecase(
        const RegisterParams(
          fullName: tFullName,
          email: tEmail,
          username: tUsername,
          password: tPassword,
          phoneNumber: tPhoneNumber,
          batchId: tBatchId,
        ),
      );

      // Assert
      expect(capturedEntity?.fullName, tFullName);
      expect(capturedEntity?.email, tEmail);
      expect(capturedEntity?.username, tUsername);
      expect(capturedEntity?.password, tPassword);
      expect(capturedEntity?.phoneNumber, tPhoneNumber);
      expect(capturedEntity?.batchId, tBatchId);
    });

    test('should handle optional parameters correctly', () async {
      // Arrange
      AuthEntity? capturedEntity;
      when(() => mockRepository.register(any())).thenAnswer((invocation) {
        capturedEntity = invocation.positionalArguments[0] as AuthEntity;
        return Future.value(const Right(true));
      });

      // Act
      await usecase(
        const RegisterParams(
          fullName: tFullName,
          email: tEmail,
          username: tUsername,
          password: tPassword,
        ),
      );

      // Assert
      expect(capturedEntity?.phoneNumber, isNull);
      expect(capturedEntity?.batchId, isNull);
    });

    test('should return failure when registration fails', () async {
      // Arrange
      const failure = ApiFailure(message: 'Email already exists');
      when(
        () => mockRepository.register(any()),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(
        const RegisterParams(
          fullName: tFullName,
          email: tEmail,
          username: tUsername,
          password: tPassword,
        ),
      );

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.register(any())).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return NetworkFailure when there is no internet', () async {
      // Arrange
      const failure = NetworkFailure();
      when(
        () => mockRepository.register(any()),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(
        const RegisterParams(
          fullName: tFullName,
          email: tEmail,
          username: tUsername,
          password: tPassword,
        ),
      );

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.register(any())).called(1);
    });
  });

  group('RegisterParams', () {
    test('should have correct props with all values', () {
      // Arrange
      const params = RegisterParams(
        fullName: tFullName,
        email: tEmail,
        username: tUsername,
        password: tPassword,
        phoneNumber: tPhoneNumber,
        batchId: tBatchId,
      );

      // Assert
      expect(params.props, [
        tFullName,
        tEmail,
        tUsername,
        tPassword,
        tPhoneNumber,
        tBatchId,
      ]);
    });

    test('should have correct props with optional values as null', () {
      // Arrange
      const params = RegisterParams(
        fullName: tFullName,
        email: tEmail,
        username: tUsername,
        password: tPassword,
      );

      // Assert
      expect(params.props, [
        tFullName,
        tEmail,
        tUsername,
        tPassword,
        null,
        null,
      ]);
    });

    test('two params with same values should be equal', () {
      // Arrange
      const params1 = RegisterParams(
        fullName: tFullName,
        email: tEmail,
        username: tUsername,
        password: tPassword,
      );
      const params2 = RegisterParams(
        fullName: tFullName,
        email: tEmail,
        username: tUsername,
        password: tPassword,
      );

      // Assert
      expect(params1, params2);
    });
  });
}
