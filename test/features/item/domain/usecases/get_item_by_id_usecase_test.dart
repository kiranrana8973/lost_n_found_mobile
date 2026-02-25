import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/features/item/domain/entities/item_entity.dart';
import 'package:lost_n_found/features/item/domain/usecases/get_item_by_id_usecase.dart';

import '../../../../mocks/test_mocks.dart';

void main() {
  late GetItemByIdUsecase usecase;
  late MockItemRepository mockItemRepository;

  setUp(() {
    mockItemRepository = MockItemRepository();
    usecase = GetItemByIdUsecase(itemRepository: mockItemRepository);
  });

  const tItemId = 'item-1';
  const tParams = GetItemByIdParams(itemId: tItemId);
  const tItemEntity = ItemEntity(
    itemId: tItemId,
    itemName: 'Lost Wallet',
    type: ItemType.lost,
    location: 'Library',
  );

  group('GetItemByIdUsecase', () {
    test('should return ItemEntity on success', () async {
      // Arrange
      when(() => mockItemRepository.getItemById(tItemId))
          .thenAnswer((_) async => const Right(tItemEntity));

      // Act
      final result = await usecase(tParams);

      // Assert
      expect(result, const Right(tItemEntity));
      verify(() => mockItemRepository.getItemById(tItemId)).called(1);
      verifyNoMoreInteractions(mockItemRepository);
    });

    test('should return Failure when repository fails', () async {
      // Arrange
      const tFailure = ApiFailure(message: 'Item not found');
      when(() => mockItemRepository.getItemById(tItemId))
          .thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await usecase(tParams);

      // Assert
      expect(result, const Left(tFailure));
      verify(() => mockItemRepository.getItemById(tItemId)).called(1);
      verifyNoMoreInteractions(mockItemRepository);
    });
  });
}
