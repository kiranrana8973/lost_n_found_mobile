import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/features/item/data/models/item_api_model.dart';
import 'package:lost_n_found/features/item/domain/entities/item_entity.dart';

void main() {
  final tCreatedAt = DateTime.parse('2024-01-15T10:30:00.000Z');
  final tUpdatedAt = DateTime.parse('2024-01-16T12:00:00.000Z');

  final tItemApiModel = ItemApiModel(
    id: '1',
    reportedBy: 'user1',
    claimedBy: null,
    category: 'cat1',
    itemName: 'Lost Wallet',
    description: 'Black leather wallet',
    type: 'lost',
    location: 'Library',
    media: 'photo.jpg',
    mediaType: 'image',
    isClaimed: false,
    status: 'available',
    createdAt: tCreatedAt,
    updatedAt: tUpdatedAt,
  );

  const tItemEntity = ItemEntity(
    itemId: '1',
    reportedBy: 'user1',
    claimedBy: null,
    category: 'cat1',
    itemName: 'Lost Wallet',
    description: 'Black leather wallet',
    type: ItemType.lost,
    location: 'Library',
    media: 'photo.jpg',
    mediaType: 'image',
    isClaimed: false,
    status: 'available',
  );

  group('fromJson', () {
    test(
      'should return a valid ItemApiModel from JSON with flat string IDs',
      () {
        final json = {
          '_id': '1',
          'reportedBy': 'user1',
          'claimedBy': null,
          'category': 'cat1',
          'itemName': 'Lost Wallet',
          'description': 'Black leather wallet',
          'type': 'lost',
          'location': 'Library',
          'media': 'photo.jpg',
          'mediaType': 'image',
          'isClaimed': false,
          'status': 'available',
          'createdAt': '2024-01-15T10:30:00.000Z',
          'updatedAt': '2024-01-16T12:00:00.000Z',
        };

        final result = ItemApiModel.fromJson(json);

        expect(result.id, '1');
        expect(result.reportedBy, 'user1');
        expect(result.category, 'cat1');
        expect(result.itemName, 'Lost Wallet');
        expect(result.description, 'Black leather wallet');
        expect(result.type, 'lost');
        expect(result.location, 'Library');
        expect(result.media, 'photo.jpg');
        expect(result.mediaType, 'image');
        expect(result.isClaimed, false);
        expect(result.status, 'available');
        expect(result.createdAt, DateTime.parse('2024-01-15T10:30:00.000Z'));
        expect(result.updatedAt, DateTime.parse('2024-01-16T12:00:00.000Z'));
      },
    );

    test(
      'should return a valid ItemApiModel from JSON with nested object IDs (extracts _id from Map)',
      () {
        final json = {
          '_id': '1',
          'reportedBy': {'_id': 'user1', 'name': 'John'},
          'claimedBy': null,
          'category': {'_id': 'cat1', 'name': 'Electronics'},
          'itemName': 'Lost Phone',
          'description': 'iPhone 15',
          'type': 'found',
          'location': 'Cafeteria',
          'media': null,
          'mediaType': null,
          'isClaimed': false,
          'status': 'available',
          'createdAt': null,
          'updatedAt': null,
        };

        final result = ItemApiModel.fromJson(json);

        expect(result.id, '1');
        expect(result.reportedBy, 'user1');
        expect(result.category, 'cat1');
        expect(result.itemName, 'Lost Phone');
        expect(result.type, 'found');
        expect(result.location, 'Cafeteria');
      },
    );
  });

  group('toJson', () {
    test('should return a JSON map with required fields', () {
      final result = tItemApiModel.toJson();

      expect(result['itemName'], 'Lost Wallet');
      expect(result['type'], 'lost');
      expect(result['location'], 'Library');
    });

    test('should conditionally include optional fields', () {
      final modelWithOptionals = ItemApiModel(
        id: '1',
        reportedBy: 'user1',
        category: 'cat1',
        itemName: 'Test',
        description: 'desc',
        type: 'lost',
        location: 'Lib',
        media: 'photo.jpg',
        mediaType: 'image',
      );

      final result = modelWithOptionals.toJson();

      expect(result.containsKey('reportedBy'), true);
      expect(result.containsKey('category'), true);
      expect(result.containsKey('description'), true);
      expect(result.containsKey('media'), true);
      expect(result.containsKey('mediaType'), true);
    });

    test('should not include optional fields when null', () {
      final modelWithoutOptionals = ItemApiModel(
        itemName: 'Test',
        type: 'lost',
        location: 'Lib',
      );

      final result = modelWithoutOptionals.toJson();

      expect(result.containsKey('reportedBy'), false);
      expect(result.containsKey('category'), false);
      expect(result.containsKey('description'), false);
      expect(result.containsKey('media'), false);
      expect(result.containsKey('mediaType'), false);
    });
  });

  group('toEntity', () {
    test(
      'should convert type string "lost" to ItemType.lost and parse dates',
      () {
        final result = tItemApiModel.toEntity();

        expect(result, isA<ItemEntity>());
        expect(result.itemId, '1');
        expect(result.type, ItemType.lost);
        expect(result.itemName, 'Lost Wallet');
        expect(result.location, 'Library');
        expect(result.createdAt, tCreatedAt);
        expect(result.updatedAt, tUpdatedAt);
      },
    );

    test('should convert type string "found" to ItemType.found', () {
      final foundModel = ItemApiModel(
        id: '2',
        itemName: 'Found Keys',
        type: 'found',
        location: 'Parking',
      );

      final result = foundModel.toEntity();

      expect(result.type, ItemType.found);
    });
  });

  group('fromEntity', () {
    test('should convert ItemType enum to string', () {
      final result = ItemApiModel.fromEntity(tItemEntity);

      expect(result, isA<ItemApiModel>());
      expect(result.type, 'lost');
      expect(result.itemName, 'Lost Wallet');
      expect(result.id, '1');
    });

    test('should convert ItemType.found to "found" string', () {
      const foundEntity = ItemEntity(
        itemId: '2',
        itemName: 'Found Keys',
        type: ItemType.found,
        location: 'Parking',
      );

      final result = ItemApiModel.fromEntity(foundEntity);

      expect(result.type, 'found');
    });
  });

  group('toEntityList', () {
    test('should convert list of ItemApiModel to list of ItemEntity', () {
      final models = [tItemApiModel, tItemApiModel];

      final result = ItemApiModel.toEntityList(models);

      expect(result, isA<List<ItemEntity>>());
      expect(result.length, 2);
      expect(result[0].itemName, 'Lost Wallet');
      expect(result[1].type, ItemType.lost);
    });
  });
}
