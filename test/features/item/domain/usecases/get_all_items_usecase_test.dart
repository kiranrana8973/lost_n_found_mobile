import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/features/item/domain/entities/item_entity.dart';
import 'package:lost_n_found/features/item/domain/repositories/item_repository.dart';
import 'package:lost_n_found/features/item/domain/usecases/get_all_items_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockItemRepository extends Mock implements IItemRepository {}

void main() {
  late GetAllItemsUsecase usecase;
  late MockItemRepository mockRepository;

  setUp(() {
    mockRepository = MockItemRepository();
    usecase = GetAllItemsUsecase(itemRepository: mockRepository);
  });

  final tItems = [
    ItemEntity(
      itemId: '1',
      itemName: 'Lost Wallet',
      description: 'Black leather wallet',
      type: ItemType.lost,
      location: 'Library',
      reportedBy: 'user1',
      createdAt: DateTime(2024, 1, 1),
    ),
    ItemEntity(
      itemId: '2',
      itemName: 'Found Keys',
      description: 'Set of car keys',
      type: ItemType.found,
      location: 'Cafeteria',
      reportedBy: 'user2',
      createdAt: DateTime(2024, 1, 2),
    ),
  ];

  group('GetAllItemsUsecase', () {
    test('should return list of items when successful', () async {
      // Arrange
      when(
        () => mockRepository.getAllItems(),
      ).thenAnswer((_) async => Right(tItems));

      // Act
      final result = await usecase();

      // Assert
      expect(result, Right(tItems));
      verify(() => mockRepository.getAllItems()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when repository fails', () async {
      // Arrange
      const failure = ApiFailure(message: 'Failed to fetch items');
      when(
        () => mockRepository.getAllItems(),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase();

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.getAllItems()).called(1);
    });

    test('should return NetworkFailure when there is no internet', () async {
      // Arrange
      const failure = NetworkFailure();
      when(
        () => mockRepository.getAllItems(),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase();

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.getAllItems()).called(1);
    });

    test('should return empty list when no items exist', () async {
      // Arrange
      when(
        () => mockRepository.getAllItems(),
      ).thenAnswer((_) async => const Right(<ItemEntity>[]));

      // Act
      final result = await usecase();

      // Assert
      expect(result, const Right(<ItemEntity>[]));
      verify(() => mockRepository.getAllItems()).called(1);
    });
  });
}
