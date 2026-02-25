import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/features/auth/domain/entities/auth_entity.dart';
import 'package:lost_n_found/features/auth/domain/usecases/get_current_user_usecase.dart';

import '../../../../mocks/test_mocks.dart';

void main() {
  late GetCurrentUserUsecase usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = GetCurrentUserUsecase(authRepository: mockAuthRepository);
  });

  const tAuthEntity = AuthEntity(
    authId: '1',
    fullName: 'Test User',
    email: 'test@example.com',
    username: 'testuser',
  );

  group('GetCurrentUserUsecase', () {
    test('should return AuthEntity when user is logged in', () async {
      when(
        () => mockAuthRepository.getCurrentUser(),
      ).thenAnswer((_) async => const Right(tAuthEntity));

      final result = await usecase();

      expect(result, const Right(tAuthEntity));
      verify(() => mockAuthRepository.getCurrentUser()).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return Failure when no user is logged in', () async {
      const tFailure = ApiFailure(message: 'No user found');
      when(
        () => mockAuthRepository.getCurrentUser(),
      ).thenAnswer((_) async => const Left(tFailure));

      final result = await usecase();

      expect(result, const Left(tFailure));
      verify(() => mockAuthRepository.getCurrentUser()).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });
  });
}
