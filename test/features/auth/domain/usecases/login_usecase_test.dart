import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/features/auth/domain/entities/auth_entity.dart';
import 'package:lost_n_found/features/auth/domain/usecases/login_usecase.dart';

import '../../../../mocks/test_mocks.dart';

void main() {
  late LoginUsecase usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = LoginUsecase(authRepository: mockAuthRepository);
  });

  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  const tParams = LoginParams(email: tEmail, password: tPassword);
  const tAuthEntity = AuthEntity(
    authId: '1',
    fullName: 'Test User',
    email: tEmail,
    username: 'testuser',
  );

  group('LoginUsecase', () {
    test('should return AuthEntity on successful login', () async {
      when(
        () => mockAuthRepository.login(tEmail, tPassword),
      ).thenAnswer((_) async => const Right(tAuthEntity));

      final result = await usecase(tParams);

      expect(result, const Right(tAuthEntity));
      verify(() => mockAuthRepository.login(tEmail, tPassword)).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return Failure on unsuccessful login', () async {
      const tFailure = ApiFailure(message: 'Invalid credentials');
      when(
        () => mockAuthRepository.login(tEmail, tPassword),
      ).thenAnswer((_) async => const Left(tFailure));

      final result = await usecase(tParams);

      expect(result, const Left(tFailure));
      verify(() => mockAuthRepository.login(tEmail, tPassword)).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });
  });
}
