import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/features/item/domain/entities/item_entity.dart';
import 'package:lost_n_found/features/item/domain/repositories/item_repository.dart';
import 'package:lost_n_found/features/item/domain/usecases/create_item_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockItemRepository extends Mock implements IItemRepository {}

void main() {
  late CreateItemUsecase usecase;
  late MockItemRepository mockRepository;

  setUp(() {
    mockRepository = MockItemRepository();
    usecase = CreateItemUsecase(itemRepository: mockRepository);
  });

  setUpAll(() {
    registerFallbackValue(
      const ItemEntity(
        itemName: 'fallback',
        type: ItemType.lost,
        location: 'fallback',
      ),
    );
  });

  const tItemName = 'Lost Wallet';
  const tDescription = 'Black leather wallet';
  const tLocation = 'Library';
  const tType = ItemType.lost;
  const tReportedBy = 'user1';

  const tParams = CreateItemParams(
    itemName: tItemName,
    description: tDescription,
    location: tLocation,
    type: tType,
    reportedBy: tReportedBy,
  );

  group('CreateItemUsecase', () {
    test('should return true when item is created successfully', () async {
      // Arrange
      when(
        () => mockRepository.createItem(any()),
      ).thenAnswer((_) async => const Right(true));

      // Act
      final result = await usecase(tParams);

      // Assert
      expect(result, const Right(true));
      verify(() => mockRepository.createItem(any())).called(1);
    });

    test('should return failure when creation fails', () async {
      // Arrange
      const failure = ApiFailure(message: 'Failed to create item');
      when(
        () => mockRepository.createItem(any()),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(tParams);

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.createItem(any())).called(1);
    });

    test('should pass correct item entity to repository', () async {
      // Arrange
      when(
        () => mockRepository.createItem(any()),
      ).thenAnswer((_) async => const Right(true));

      // Act
      await usecase(tParams);

      // Assert
      final captured =
          verify(() => mockRepository.createItem(captureAny())).captured.first
              as ItemEntity;

      expect(captured.itemName, tItemName);
      expect(captured.description, tDescription);
      expect(captured.location, tLocation);
      expect(captured.type, tType);
      expect(captured.reportedBy, tReportedBy);
    });

    test(
      'should succeed with valid params and fail with invalid params',
      () async {
        // Arrange
        const validParams = CreateItemParams(
          itemName: tItemName,
          location: tLocation,
          type: tType,
        );
        const invalidParams = CreateItemParams(
          itemName: '',
          location: tLocation,
          type: tType,
        );
        const failure = ApiFailure(message: 'Invalid item name');

        when(() => mockRepository.createItem(any())).thenAnswer((
          invocation,
        ) async {
          final item = invocation.positionalArguments[0] as ItemEntity;

          if (item.itemName.isNotEmpty) {
            return const Right(true);
          }
          return const Left(failure);
        });

        // Act & Assert - Valid params should succeed
        final successResult = await usecase(validParams);
        expect(successResult, const Right(true));

        // Act & Assert - Invalid params should fail
        final failResult = await usecase(invalidParams);
        expect(failResult, const Left(failure));
      },
    );
  });

  group('CreateItemParams', () {
    test('should have correct props', () {
      expect(tParams.props, [
        tItemName,
        tDescription,
        null, // category
        tLocation,
        tType,
        tReportedBy,
        null, // media
        null, // mediaType
      ]);
    });

    test('two params with same values should be equal', () {
      const params1 = CreateItemParams(
        itemName: tItemName,
        location: tLocation,
        type: tType,
      );
      const params2 = CreateItemParams(
        itemName: tItemName,
        location: tLocation,
        type: tType,
      );
      expect(params1, params2);
    });

    test('two params with different values should not be equal', () {
      const params1 = CreateItemParams(
        itemName: tItemName,
        location: tLocation,
        type: tType,
      );
      const params2 = CreateItemParams(
        itemName: 'Other Item',
        location: tLocation,
        type: tType,
      );
      expect(params1, isNot(params2));
    });
  });
}
