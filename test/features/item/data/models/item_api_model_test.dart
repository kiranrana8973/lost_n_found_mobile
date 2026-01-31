import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/features/item/data/models/item_api_model.dart';
import 'package:lost_n_found/features/item/domain/entities/item_entity.dart';

void main() {
  group('ItemApiModel', () {
    final tDateTime = DateTime(2024, 1, 1, 12, 0, 0);
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
      createdAt: tDateTime,
      updatedAt: tDateTime,
    );

    final tItemEntity = ItemEntity(
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
      createdAt: tDateTime,
      updatedAt: tDateTime,
    );

    group('fromJson', () {
      test('should return a valid model from JSON', () {
        // Arrange
        final json = {
          '_id': '1',
          'reportedBy': 'user1',
          'claimedBy': null,
          'category': 'electronics',
          'itemName': 'Test Item',
          'description': 'Test Description',
          'type': 'lost',
          'location': 'Test Location',
          'media': 'http://example.com/image.jpg',
          'mediaType': 'image',
          'isClaimed': false,
          'status': 'available',
          'createdAt': '2024-01-01T12:00:00.000',
          'updatedAt': '2024-01-01T12:00:00.000',
        };

        // Act
        final result = ItemApiModel.fromJson(json);

        // Assert
        expect(result.id, '1');
        expect(result.itemName, 'Test Item');
        expect(result.type, 'lost');
        expect(result.location, 'Test Location');
      });

      test('should handle nested reportedBy object', () {
        // Arrange
        final json = {
          '_id': '1',
          'reportedBy': {'_id': 'user1', 'name': 'Test User'},
          'itemName': 'Test Item',
          'type': 'lost',
          'location': 'Test Location',
        };

        // Act
        final result = ItemApiModel.fromJson(json);

        // Assert
        expect(result.reportedBy, 'user1');
      });

      test('should handle nested category object', () {
        // Arrange
        final json = {
          '_id': '1',
          'category': {'_id': 'cat1', 'name': 'Electronics'},
          'itemName': 'Test Item',
          'type': 'found',
          'location': 'Test Location',
        };

        // Act
        final result = ItemApiModel.fromJson(json);

        // Assert
        expect(result.category, 'cat1');
      });

      test('should handle nested claimedBy object', () {
        // Arrange
        final json = {
          '_id': '1',
          'claimedBy': {'_id': 'user2', 'name': 'Claimer'},
          'itemName': 'Test Item',
          'type': 'found',
          'location': 'Test Location',
        };

        // Act
        final result = ItemApiModel.fromJson(json);

        // Assert
        expect(result.claimedBy, 'user2');
      });

      test('should default isClaimed to false when not provided', () {
        // Arrange
        final json = {
          '_id': '1',
          'itemName': 'Test Item',
          'type': 'lost',
          'location': 'Test Location',
        };

        // Act
        final result = ItemApiModel.fromJson(json);

        // Assert
        expect(result.isClaimed, false);
      });
    });

    group('toJson', () {
      test('should return a valid JSON map', () {
        // Act
        final result = tItemApiModel.toJson();

        // Assert
        expect(result['itemName'], 'Test Item');
        expect(result['type'], 'lost');
        expect(result['location'], 'Test Location');
        expect(result['description'], 'Test Description');
        expect(result['isClaimed'], false);
      });
    });

    group('toEntity', () {
      test('should convert to ItemEntity with lost type', () {
        // Act
        final result = tItemApiModel.toEntity();

        // Assert
        expect(result.itemId, '1');
        expect(result.itemName, 'Test Item');
        expect(result.type, ItemType.lost);
        expect(result.location, 'Test Location');
        expect(result.description, 'Test Description');
        expect(result.isClaimed, false);
      });

      test('should convert to ItemEntity with found type', () {
        // Arrange
        final foundModel = ItemApiModel(
          id: '2',
          itemName: 'Found Item',
          type: 'found',
          location: 'Found Location',
        );

        // Act
        final result = foundModel.toEntity();

        // Assert
        expect(result.type, ItemType.found);
      });
    });

    group('fromEntity', () {
      test('should convert from ItemEntity with lost type', () {
        // Act
        final result = ItemApiModel.fromEntity(tItemEntity);

        // Assert
        expect(result.id, '1');
        expect(result.itemName, 'Test Item');
        expect(result.type, 'lost');
        expect(result.location, 'Test Location');
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
        final result = ItemApiModel.fromEntity(foundEntity);

        // Assert
        expect(result.type, 'found');
      });
    });

    group('toEntityList', () {
      test('should convert list of models to list of entities', () {
        // Arrange
        final models = [
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
        final result = ItemApiModel.toEntityList(models);

        // Assert
        expect(result.length, 2);
        expect(result[0].itemName, 'Item 1');
        expect(result[0].type, ItemType.lost);
        expect(result[1].itemName, 'Item 2');
        expect(result[1].type, ItemType.found);
      });

      test('should return empty list when given empty list', () {
        // Act
        final result = ItemApiModel.toEntityList([]);

        // Assert
        expect(result, isEmpty);
      });
    });
  });
}
