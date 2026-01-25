import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/features/batch/domain/repositories/batch_repository.dart';
import 'package:lost_n_found/features/batch/domain/usecases/delete_batch_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockBatchRepository extends Mock implements IBatchRepository {}

void main() {
  late DeleteBatchUsecase usecase;
  late MockBatchRepository mockRepository;

  setUp(() {
    mockRepository = MockBatchRepository();
    usecase = DeleteBatchUsecase(batchRepository: mockRepository);
  });

  const tBatchId = '1';

  group('DeleteBatchUsecase', () {
    test('should return true when batch is deleted successfully', () async {
      // Arrange
      when(() => mockRepository.deleteBatch(tBatchId))
          .thenAnswer((_) async => const Right(true));

      // Act
      final result =
          await usecase(const DeleteBatchParams(batchId: tBatchId));

      // Assert
      expect(result, const Right(true));
      verify(() => mockRepository.deleteBatch(tBatchId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when repository call fails', () async {
      // Arrange
      const failure = ApiFailure(message: 'Failed to delete batch');
      when(() => mockRepository.deleteBatch(tBatchId))
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result =
          await usecase(const DeleteBatchParams(batchId: tBatchId));

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.deleteBatch(tBatchId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return NetworkFailure when there is no internet', () async {
      // Arrange
      const failure = NetworkFailure();
      when(() => mockRepository.deleteBatch(tBatchId))
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result =
          await usecase(const DeleteBatchParams(batchId: tBatchId));

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.deleteBatch(tBatchId)).called(1);
    });

    test('should return LocalDatabaseFailure on local db error', () async {
      // Arrange
      const failure = LocalDatabaseFailure();
      when(() => mockRepository.deleteBatch(tBatchId))
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result =
          await usecase(const DeleteBatchParams(batchId: tBatchId));

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.deleteBatch(tBatchId)).called(1);
    });
  });

  group('DeleteBatchParams', () {
    test('should have correct props', () {
      // Arrange
      const params = DeleteBatchParams(batchId: tBatchId);

      // Assert
      expect(params.props, [tBatchId]);
    });

    test('two params with same batchId should be equal', () {
      // Arrange
      const params1 = DeleteBatchParams(batchId: tBatchId);
      const params2 = DeleteBatchParams(batchId: tBatchId);

      // Assert
      expect(params1, params2);
    });
  });
}
