import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/features/item/domain/entities/item_entity.dart';
import 'package:lost_n_found/features/item/domain/usecases/get_all_items_usecase.dart';

import '../../../../mocks/test_mocks.dart';

void main() {
  late GetAllItemsUsecase usecase;
  late MockItemRepository mockItemRepository;

  setUp(() {
    mockItemRepository = MockItemRepository();
    usecase = GetAllItemsUsecase(itemRepository: mockItemRepository);
  });

  final tItemList = [
    const ItemEntity(
      itemId: '1',
      itemName: 'Lost Wallet',
      type: ItemType.lost,
      location: 'Library',
    ),
    const ItemEntity(
      itemId: '2',
      itemName: 'Found Keys',
      type: ItemType.found,
      location: 'Cafeteria',
    ),
  ];

  group('GetAllItemsUsecase', () {
    test('should return list of items on success', () async {
      when(
        () => mockItemRepository.getAllItems(),
      ).thenAnswer((_) async => Right(tItemList));

      final result = await usecase();

      expect(result, Right(tItemList));
      verify(() => mockItemRepository.getAllItems()).called(1);
      verifyNoMoreInteractions(mockItemRepository);
    });

    test('should return Failure when repository fails', () async {
      const tFailure = ApiFailure(message: 'Failed to fetch items');
      when(
        () => mockItemRepository.getAllItems(),
      ).thenAnswer((_) async => const Left(tFailure));

      final result = await usecase();

      expect(result, const Left(tFailure));
      verify(() => mockItemRepository.getAllItems()).called(1);
      verifyNoMoreInteractions(mockItemRepository);
    });
  });
}
