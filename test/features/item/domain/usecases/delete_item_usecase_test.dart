import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/features/item/domain/usecases/delete_item_usecase.dart';

import '../../../../mocks/test_mocks.dart';

void main() {
  late DeleteItemUsecase usecase;
  late MockItemRepository mockItemRepository;

  setUp(() {
    mockItemRepository = MockItemRepository();
    usecase = DeleteItemUsecase(itemRepository: mockItemRepository);
  });

  const tItemId = 'item-1';
  const tParams = DeleteItemParams(itemId: tItemId);

  group('DeleteItemUsecase', () {
    test('should return true on successful item deletion', () async {
      // Arrange
      when(() => mockItemRepository.deleteItem(tItemId))
          .thenAnswer((_) async => const Right(true));

      // Act
      final result = await usecase(tParams);

      // Assert
      expect(result, const Right(true));
      verify(() => mockItemRepository.deleteItem(tItemId)).called(1);
      verifyNoMoreInteractions(mockItemRepository);
    });

    test('should return Failure on unsuccessful item deletion', () async {
      // Arrange
      const tFailure = ApiFailure(message: 'Failed to delete item');
      when(() => mockItemRepository.deleteItem(tItemId))
          .thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await usecase(tParams);

      // Assert
      expect(result, const Left(tFailure));
      verify(() => mockItemRepository.deleteItem(tItemId)).called(1);
      verifyNoMoreInteractions(mockItemRepository);
    });
  });
}
