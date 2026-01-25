import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/features/batch/domain/entities/batch_entity.dart';
import 'package:lost_n_found/features/batch/domain/repositories/batch_repository.dart';
import 'package:lost_n_found/features/batch/domain/usecases/get_batch_byid_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockBatchRepository extends Mock implements IBatchRepository {}

void main() {
  late GetBatchByIdUsecase usecase;
  late MockBatchRepository mockRepository;

  setUp(() {
    mockRepository = MockBatchRepository();
    usecase = GetBatchByIdUsecase(batchRepository: mockRepository);
  });

  const tBatchId = '1';
  const tBatch = BatchEntity(
    batchId: '1',
    batchName: 'Test Batch',
    status: 'active',
  );

  group('GetBatchByIdUsecase', () {
    test('should return batch entity when repository call is successful',
        () async {
      // Arrange
      when(() => mockRepository.getBatchById(tBatchId))
          .thenAnswer((_) async => const Right(tBatch));

      // Act
      final result = await usecase(const GetBatchByIdParams(batchId: tBatchId));

      // Assert
      expect(result, const Right(tBatch));
      verify(() => mockRepository.getBatchById(tBatchId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when repository call fails', () async {
      // Arrange
      const failure = ApiFailure(message: 'Batch not found');
      when(() => mockRepository.getBatchById(tBatchId))
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(const GetBatchByIdParams(batchId: tBatchId));

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.getBatchById(tBatchId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return NetworkFailure when there is no internet', () async {
      // Arrange
      const failure = NetworkFailure();
      when(() => mockRepository.getBatchById(tBatchId))
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(const GetBatchByIdParams(batchId: tBatchId));

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.getBatchById(tBatchId)).called(1);
    });
  });

  group('GetBatchByIdParams', () {
    test('should have correct props', () {
      // Arrange
      const params = GetBatchByIdParams(batchId: tBatchId);

      // Assert
      expect(params.props, [tBatchId]);
    });

    test('two params with same batchId should be equal', () {
      // Arrange
      const params1 = GetBatchByIdParams(batchId: tBatchId);
      const params2 = GetBatchByIdParams(batchId: tBatchId);

      // Assert
      expect(params1, params2);
    });
  });
}
