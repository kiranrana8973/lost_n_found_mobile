import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/features/item/domain/entities/item_entity.dart';
import 'package:lost_n_found/features/item/domain/usecases/create_item_usecase.dart';

import '../../../../mocks/test_mocks.dart';

void main() {
  late CreateItemUsecase usecase;
  late MockItemRepository mockItemRepository;

  setUpAll(() {
    registerFallbackValue(const ItemEntity(
      itemName: '',
      type: ItemType.lost,
      location: '',
    ));
  });

  setUp(() {
    mockItemRepository = MockItemRepository();
    usecase = CreateItemUsecase(itemRepository: mockItemRepository);
  });

  const tParams = CreateItemParams(
    itemName: 'Lost Wallet',
    description: 'Black leather wallet',
    category: 'cat-1',
    location: 'Library',
    type: ItemType.lost,
    reportedBy: 'user-1',
    media: 'photo.jpg',
    mediaType: 'image',
  );

  group('CreateItemUsecase', () {
    test('should return true on successful item creation', () async {
      // Arrange
      when(() => mockItemRepository.createItem(any()))
          .thenAnswer((_) async => const Right(true));

      // Act
      final result = await usecase(tParams);

      // Assert
      expect(result, const Right(true));
      verify(() => mockItemRepository.createItem(any())).called(1);
      verifyNoMoreInteractions(mockItemRepository);
    });

    test('should return Failure on unsuccessful item creation', () async {
      // Arrange
      const tFailure = ApiFailure(message: 'Failed to create item');
      when(() => mockItemRepository.createItem(any()))
          .thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await usecase(tParams);

      // Assert
      expect(result, const Left(tFailure));
      verify(() => mockItemRepository.createItem(any())).called(1);
      verifyNoMoreInteractions(mockItemRepository);
    });
  });
}
