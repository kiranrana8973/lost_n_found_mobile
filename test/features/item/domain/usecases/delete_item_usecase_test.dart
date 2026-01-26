import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/features/item/domain/repositories/item_repository.dart';
import 'package:lost_n_found/features/item/domain/usecases/delete_item_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockItemRepository extends Mock implements IItemRepository {}

void main() {
  late DeleteItemUsecase usecase;
  late MockItemRepository mockRepository;

  setUp(() {
    mockRepository = MockItemRepository();
    usecase = DeleteItemUsecase(itemRepository: mockRepository);
  });

  const tItemId = '123';
  const tParams = DeleteItemParams(itemId: tItemId);

  group('DeleteItemUsecase', () {
    test('should return true when item is deleted successfully', () async {
      // Arrange
      when(
        () => mockRepository.deleteItem(tItemId),
      ).thenAnswer((_) async => const Right(true));

      // Act
      final result = await usecase(tParams);

      // Assert
      expect(result, const Right(true));
      verify(() => mockRepository.deleteItem(tItemId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when deletion fails', () async {
      // Arrange
      const failure = ApiFailure(message: 'Failed to delete item');
      when(
        () => mockRepository.deleteItem(tItemId),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(tParams);

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.deleteItem(tItemId)).called(1);
    });

    test('should return failure when item not found', () async {
      // Arrange
      const failure = ApiFailure(message: 'Item not found');
      when(
        () => mockRepository.deleteItem(tItemId),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(tParams);

      // Assert
      expect(result, const Left(failure));
    });

    test(
      'should succeed with valid id and fail with invalid id',
      () async {
        // Arrange
        const validId = '123';
        const invalidId = '';
        const failure = ApiFailure(message: 'Invalid item id');

        when(() => mockRepository.deleteItem(any())).thenAnswer((
          invocation,
        ) async {
          final itemId = invocation.positionalArguments[0] as String;

          if (itemId.isNotEmpty) {
            return const Right(true);
          }
          return const Left(failure);
        });

        // Act & Assert - Valid id should succeed
        final successResult = await usecase(
          const DeleteItemParams(itemId: validId),
        );
        expect(successResult, const Right(true));

        // Act & Assert - Invalid id should fail
        final failResult = await usecase(
          const DeleteItemParams(itemId: invalidId),
        );
        expect(failResult, const Left(failure));
      },
    );
  });

  group('DeleteItemParams', () {
    test('should have correct props', () {
      expect(tParams.props, [tItemId]);
    });

    test('two params with same values should be equal', () {
      const params1 = DeleteItemParams(itemId: tItemId);
      const params2 = DeleteItemParams(itemId: tItemId);
      expect(params1, params2);
    });

    test('two params with different values should not be equal', () {
      const params1 = DeleteItemParams(itemId: tItemId);
      const params2 = DeleteItemParams(itemId: '456');
      expect(params1, isNot(params2));
    });
  });
}
