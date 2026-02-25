import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/features/auth/domain/usecases/logout_usecase.dart';

import '../../../../mocks/test_mocks.dart';

void main() {
  late LogoutUsecase usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = LogoutUsecase(authRepository: mockAuthRepository);
  });

  group('LogoutUsecase', () {
    test('should return true on successful logout', () async {
      when(
        () => mockAuthRepository.logout(),
      ).thenAnswer((_) async => const Right(true));

      final result = await usecase();

      expect(result, const Right(true));
      verify(() => mockAuthRepository.logout()).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return Failure on unsuccessful logout', () async {
      const tFailure = ApiFailure(message: 'Logout failed');
      when(
        () => mockAuthRepository.logout(),
      ).thenAnswer((_) async => const Left(tFailure));

      final result = await usecase();

      expect(result, const Left(tFailure));
      verify(() => mockAuthRepository.logout()).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });
  });
}
