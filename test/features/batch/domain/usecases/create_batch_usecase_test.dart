import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/features/batch/domain/entities/batch_entity.dart';
import 'package:lost_n_found/features/batch/domain/repositories/batch_repository.dart';
import 'package:lost_n_found/features/batch/domain/usecases/create_batch_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockBatchRepository extends Mock implements IBatchRepository {}

void main() {
  late CreateBatchUsecase usecase;
  late MockBatchRepository mockRepository;

  setUp(() {
    mockRepository = MockBatchRepository();
    usecase = CreateBatchUsecase(batchRepository: mockRepository);
  });

  setUpAll(() {
    registerFallbackValue(const BatchEntity(batchName: 'fallback'));
  });

  const tBatchName = 'New Batch';

  group('CreateBatchUsecase', () {
    test('should return true when batch is created successfully', () async {
      // Arrange
      when(
        () => mockRepository.createBatch(any()),
      ).thenAnswer((_) async => const Right(true));

      // Act
      final result = await usecase(
        const CreateBatchParams(batchName: tBatchName),
      );

      // Assert
      expect(result, const Right(true));
      verify(() => mockRepository.createBatch(any())).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test(
      'should pass BatchEntity with correct batchName to repository',
      () async {
        // Arrange
        BatchEntity? capturedEntity;
        when(() => mockRepository.createBatch(any())).thenAnswer((invocation) {
          capturedEntity = invocation.positionalArguments[0] as BatchEntity;
          return Future.value(const Right(true));
        });

        // Act
        await usecase(const CreateBatchParams(batchName: tBatchName));

        // Assert
        expect(capturedEntity?.batchName, tBatchName);
        expect(capturedEntity?.batchId, isNull);
      },
    );

    test('should return failure when repository call fails', () async {
      // Arrange
      const failure = ApiFailure(message: 'Failed to create batch');
      when(
        () => mockRepository.createBatch(any()),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(
        const CreateBatchParams(batchName: tBatchName),
      );

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.createBatch(any())).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return NetworkFailure when there is no internet', () async {
      // Arrange
      const failure = NetworkFailure();
      when(
        () => mockRepository.createBatch(any()),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(
        const CreateBatchParams(batchName: tBatchName),
      );

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.createBatch(any())).called(1);
    });
  });

  group('CreateBatchParams', () {
    test('should have correct props', () {
      // Arrange
      const params = CreateBatchParams(batchName: tBatchName);

      // Assert
      expect(params.props, [tBatchName]);
    });

    test('two params with same batchName should be equal', () {
      // Arrange
      const params1 = CreateBatchParams(batchName: tBatchName);
      const params2 = CreateBatchParams(batchName: tBatchName);

      // Assert
      expect(params1, params2);
    });
  });
}
