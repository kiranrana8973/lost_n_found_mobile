import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/features/auth/domain/entities/auth_entity.dart';
import 'package:lost_n_found/features/auth/domain/usecases/register_usecase.dart';

import '../../../../mocks/test_mocks.dart';

void main() {
  late RegisterUsecase usecase;
  late MockAuthRepository mockAuthRepository;

  setUpAll(() {
    registerFallbackValue(
      const AuthEntity(fullName: '', email: '', username: ''),
    );
  });

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = RegisterUsecase(authRepository: mockAuthRepository);
  });

  const tParams = RegisterParams(
    fullName: 'Test User',
    email: 'test@example.com',
    username: 'testuser',
    password: 'password123',
    phoneNumber: '1234567890',
    batchId: 'batch-1',
  );

  group('RegisterUsecase', () {
    test('should return true on successful registration', () async {
      when(
        () => mockAuthRepository.register(any()),
      ).thenAnswer((_) async => const Right(true));

      final result = await usecase(tParams);

      expect(result, const Right(true));
      verify(() => mockAuthRepository.register(any())).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return Failure on unsuccessful registration', () async {
      const tFailure = ApiFailure(message: 'Email already exists');
      when(
        () => mockAuthRepository.register(any()),
      ).thenAnswer((_) async => const Left(tFailure));

      final result = await usecase(tParams);

      expect(result, const Left(tFailure));
      verify(() => mockAuthRepository.register(any())).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });
  });
}
