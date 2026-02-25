import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/features/item/domain/entities/item_entity.dart';
import 'package:lost_n_found/features/item/domain/usecases/update_item_usecase.dart';

import '../../../../mocks/test_mocks.dart';

void main() {
  late UpdateItemUsecase usecase;
  late MockItemRepository mockItemRepository;

  setUpAll(() {
    registerFallbackValue(
      const ItemEntity(itemName: '', type: ItemType.lost, location: ''),
    );
  });

  setUp(() {
    mockItemRepository = MockItemRepository();
    usecase = UpdateItemUsecase(itemRepository: mockItemRepository);
  });

  const tParams = UpdateItemParams(
    itemId: 'item-1',
    itemName: 'Updated Wallet',
    description: 'Brown leather wallet',
    category: 'cat-1',
    location: 'Cafeteria',
    type: ItemType.lost,
    claimedBy: 'user-2',
    media: 'photo.jpg',
    mediaType: 'image',
    isClaimed: true,
    status: 'claimed',
  );

  group('UpdateItemUsecase', () {
    test('should return true on successful item update', () async {
      when(
        () => mockItemRepository.updateItem(any()),
      ).thenAnswer((_) async => const Right(true));

      final result = await usecase(tParams);

      expect(result, const Right(true));
      verify(() => mockItemRepository.updateItem(any())).called(1);
      verifyNoMoreInteractions(mockItemRepository);
    });

    test('should return Failure on unsuccessful item update', () async {
      const tFailure = ApiFailure(message: 'Failed to update item');
      when(
        () => mockItemRepository.updateItem(any()),
      ).thenAnswer((_) async => const Left(tFailure));

      final result = await usecase(tParams);

      expect(result, const Left(tFailure));
      verify(() => mockItemRepository.updateItem(any())).called(1);
      verifyNoMoreInteractions(mockItemRepository);
    });
  });
}
