import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/features/item/domain/entities/item_entity.dart';
import 'package:lost_n_found/features/item/domain/usecases/get_items_by_user_usecase.dart';

import '../../../../mocks/test_mocks.dart';

void main() {
  late GetItemsByUserUsecase usecase;
  late MockItemRepository mockItemRepository;

  setUp(() {
    mockItemRepository = MockItemRepository();
    usecase = GetItemsByUserUsecase(itemRepository: mockItemRepository);
  });

  const tUserId = 'user-1';
  const tParams = GetItemsByUserParams(userId: tUserId);
  final tItemList = [
    const ItemEntity(
      itemId: '1',
      itemName: 'Lost Wallet',
      type: ItemType.lost,
      location: 'Library',
      reportedBy: tUserId,
    ),
    const ItemEntity(
      itemId: '2',
      itemName: 'Found Keys',
      type: ItemType.found,
      location: 'Cafeteria',
      reportedBy: tUserId,
    ),
  ];

  group('GetItemsByUserUsecase', () {
    test('should return list of items for a user on success', () async {
      when(
        () => mockItemRepository.getItemsByUser(tUserId),
      ).thenAnswer((_) async => Right(tItemList));

      final result = await usecase(tParams);

      expect(result, Right(tItemList));
      verify(() => mockItemRepository.getItemsByUser(tUserId)).called(1);
      verifyNoMoreInteractions(mockItemRepository);
    });

    test('should return Failure when repository fails', () async {
      const tFailure = ApiFailure(message: 'Failed to fetch user items');
      when(
        () => mockItemRepository.getItemsByUser(tUserId),
      ).thenAnswer((_) async => const Left(tFailure));

      final result = await usecase(tParams);

      expect(result, const Left(tFailure));
      verify(() => mockItemRepository.getItemsByUser(tUserId)).called(1);
      verifyNoMoreInteractions(mockItemRepository);
    });
  });
}
