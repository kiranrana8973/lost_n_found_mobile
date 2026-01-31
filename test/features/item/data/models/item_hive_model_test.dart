import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/features/item/data/models/item_api_model.dart';
import 'package:lost_n_found/features/item/data/models/item_hive_model.dart';
import 'package:lost_n_found/features/item/domain/entities/item_entity.dart';

void main() {
  group('ItemHiveModel', () {
    final tItemHiveModel = ItemHiveModel(
      itemId: '1',
      reportedBy: 'user1',
      claimedBy: null,
      category: 'electronics',
      itemName: 'Test Item',
      description: 'Test Description',
      type: 'lost',
      location: 'Test Location',
      media: 'http://example.com/image.jpg',
      mediaType: 'image',
      isClaimed: false,
      status: 'available',
    );

    const tItemEntity = ItemEntity(
      itemId: '1',
      reportedBy: 'user1',
      claimedBy: null,
      category: 'electronics',
      itemName: 'Test Item',
      description: 'Test Description',
      type: ItemType.lost,
      location: 'Test Location',
      media: 'http://example.com/image.jpg',
      mediaType: 'image',
      isClaimed: false,
      status: 'available',
    );

    final tItemApiModel = ItemApiModel(
      id: '1',
      reportedBy: 'user1',
      claimedBy: null,
      category: 'electronics',
      itemName: 'Test Item',
      description: 'Test Description',
      type: 'lost',
      location: 'Test Location',
      media: 'http://example.com/image.jpg',
      mediaType: 'image',
      isClaimed: false,
      status: 'available',
    );

    group('constructor', () {
      test('should generate UUID when itemId is null', () {
        // Act
        final model = ItemHiveModel(
          itemName: 'Test Item',
          type: 'lost',
          location: 'Test Location',
        );

        // Assert
        expect(model.itemId, isNotNull);
        expect(model.itemId!.length, greaterThan(0));
      });

      test('should default isClaimed to false when null', () {
        // Act
        final model = ItemHiveModel(
          itemName: 'Test Item',
          type: 'lost',
          location: 'Test Location',
        );

        // Assert
        expect(model.isClaimed, false);
      });

      test('should default status to available when null', () {
        // Act
        final model = ItemHiveModel(
          itemName: 'Test Item',
          type: 'lost',
          location: 'Test Location',
        );

        // Assert
        expect(model.status, 'available');
      });

      test('should use provided itemId when not null', () {
        // Act
        final model = ItemHiveModel(
          itemId: 'custom-id',
          itemName: 'Test Item',
          type: 'lost',
          location: 'Test Location',
        );

        // Assert
        expect(model.itemId, 'custom-id');
      });
    });

    group('toEntity', () {
      test('should convert to ItemEntity with lost type', () {
        // Act
        final result = tItemHiveModel.toEntity();

        // Assert
        expect(result.itemId, '1');
        expect(result.itemName, 'Test Item');
        expect(result.type, ItemType.lost);
        expect(result.location, 'Test Location');
        expect(result.description, 'Test Description');
        expect(result.reportedBy, 'user1');
        expect(result.category, 'electronics');
        expect(result.isClaimed, false);
        expect(result.status, 'available');
      });

      test('should convert to ItemEntity with found type', () {
        // Arrange
        final foundModel = ItemHiveModel(
          itemId: '2',
          itemName: 'Found Item',
          type: 'found',
          location: 'Found Location',
        );

        // Act
        final result = foundModel.toEntity();

        // Assert
        expect(result.type, ItemType.found);
      });

      test('should handle null optional fields', () {
        // Arrange
        final minimalModel = ItemHiveModel(
          itemId: '3',
          itemName: 'Minimal Item',
          type: 'lost',
          location: 'Minimal Location',
        );

        // Act
        final result = minimalModel.toEntity();

        // Assert
        expect(result.description, isNull);
        expect(result.media, isNull);
        expect(result.mediaType, isNull);
        expect(result.reportedBy, isNull);
        expect(result.claimedBy, isNull);
        expect(result.category, isNull);
      });
    });

    group('fromEntity', () {
      test('should convert from ItemEntity with lost type', () {
        // Act
        final result = ItemHiveModel.fromEntity(tItemEntity);

        // Assert
        expect(result.itemId, '1');
        expect(result.itemName, 'Test Item');
        expect(result.type, 'lost');
        expect(result.location, 'Test Location');
        expect(result.description, 'Test Description');
        expect(result.reportedBy, 'user1');
        expect(result.category, 'electronics');
      });

      test('should convert from ItemEntity with found type', () {
        // Arrange
        const foundEntity = ItemEntity(
          itemId: '2',
          itemName: 'Found Item',
          type: ItemType.found,
          location: 'Found Location',
        );

        // Act
        final result = ItemHiveModel.fromEntity(foundEntity);

        // Assert
        expect(result.type, 'found');
      });
    });

    group('toEntityList', () {
      test('should convert list of hive models to list of entities', () {
        // Arrange
        final models = [
          ItemHiveModel(
            itemId: '1',
            itemName: 'Item 1',
            type: 'lost',
            location: 'Location 1',
          ),
          ItemHiveModel(
            itemId: '2',
            itemName: 'Item 2',
            type: 'found',
            location: 'Location 2',
          ),
        ];

        // Act
        final result = ItemHiveModel.toEntityList(models);

        // Assert
        expect(result.length, 2);
        expect(result[0].itemName, 'Item 1');
        expect(result[0].type, ItemType.lost);
        expect(result[1].itemName, 'Item 2');
        expect(result[1].type, ItemType.found);
      });

      test('should return empty list when given empty list', () {
        // Act
        final result = ItemHiveModel.toEntityList([]);

        // Assert
        expect(result, isEmpty);
      });
    });

    group('fromApiModel', () {
      test('should convert from ItemApiModel', () {
        // Act
        final result = ItemHiveModel.fromApiModel(tItemApiModel);

        // Assert
        expect(result.itemId, '1');
        expect(result.itemName, 'Test Item');
        expect(result.type, 'lost');
        expect(result.location, 'Test Location');
        expect(result.description, 'Test Description');
        expect(result.reportedBy, 'user1');
        expect(result.category, 'electronics');
        expect(result.isClaimed, false);
        expect(result.status, 'available');
      });

      test('should handle null optional fields in ApiModel', () {
        // Arrange
        final minimalApiModel = ItemApiModel(
          id: '3',
          itemName: 'Minimal Item',
          type: 'found',
          location: 'Minimal Location',
        );

        // Act
        final result = ItemHiveModel.fromApiModel(minimalApiModel);

        // Assert
        expect(result.itemId, '3');
        expect(result.description, isNull);
        expect(result.media, isNull);
        expect(result.reportedBy, isNull);
      });
    });

    group('fromApiModelList', () {
      test('should convert list of API models to list of Hive models', () {
        // Arrange
        final apiModels = [
          ItemApiModel(
            id: '1',
            itemName: 'Item 1',
            type: 'lost',
            location: 'Location 1',
          ),
          ItemApiModel(
            id: '2',
            itemName: 'Item 2',
            type: 'found',
            location: 'Location 2',
          ),
        ];

        // Act
        final result = ItemHiveModel.fromApiModelList(apiModels);

        // Assert
        expect(result.length, 2);
        expect(result[0].itemId, '1');
        expect(result[0].itemName, 'Item 1');
        expect(result[0].type, 'lost');
        expect(result[1].itemId, '2');
        expect(result[1].itemName, 'Item 2');
        expect(result[1].type, 'found');
      });

      test('should return empty list when given empty list', () {
        // Act
        final result = ItemHiveModel.fromApiModelList([]);

        // Assert
        expect(result, isEmpty);
      });
    });
  });
}
