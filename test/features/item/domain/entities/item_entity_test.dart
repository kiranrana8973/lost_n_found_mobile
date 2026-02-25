import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/features/item/domain/entities/item_entity.dart';

void main() {
  final tCreatedAt = DateTime(2024, 1, 15, 10, 30);
  final tUpdatedAt = DateTime(2024, 1, 16, 12, 0);

  final tItemEntity = ItemEntity(
    itemId: 'item-123',
    reportedBy: 'user-1',
    claimedBy: 'user-2',
    category: 'electronics',
    itemName: 'Lost Phone',
    description: 'Black iPhone found near library',
    type: ItemType.lost,
    location: 'Library',
    media: 'https://example.com/photo.jpg',
    mediaType: 'image',
    isClaimed: true,
    status: 'active',
    createdAt: tCreatedAt,
    updatedAt: tUpdatedAt,
  );

  group('ItemEntity', () {
    test('should create an ItemEntity with required fields only', () {
      const entity = ItemEntity(
        itemName: 'Lost Wallet',
        type: ItemType.found,
        location: 'Cafeteria',
      );

      expect(entity.itemName, 'Lost Wallet');
      expect(entity.type, ItemType.found);
      expect(entity.location, 'Cafeteria');
      expect(entity.itemId, isNull);
      expect(entity.reportedBy, isNull);
      expect(entity.claimedBy, isNull);
      expect(entity.category, isNull);
      expect(entity.description, isNull);
      expect(entity.media, isNull);
      expect(entity.mediaType, isNull);
      expect(entity.isClaimed, false);
      expect(entity.status, isNull);
      expect(entity.createdAt, isNull);
      expect(entity.updatedAt, isNull);
    });

    test('should create an ItemEntity with all fields', () {
      expect(tItemEntity.itemId, 'item-123');
      expect(tItemEntity.reportedBy, 'user-1');
      expect(tItemEntity.claimedBy, 'user-2');
      expect(tItemEntity.category, 'electronics');
      expect(tItemEntity.itemName, 'Lost Phone');
      expect(tItemEntity.description, 'Black iPhone found near library');
      expect(tItemEntity.type, ItemType.lost);
      expect(tItemEntity.location, 'Library');
      expect(tItemEntity.media, 'https://example.com/photo.jpg');
      expect(tItemEntity.mediaType, 'image');
      expect(tItemEntity.isClaimed, true);
      expect(tItemEntity.status, 'active');
      expect(tItemEntity.createdAt, tCreatedAt);
      expect(tItemEntity.updatedAt, tUpdatedAt);
    });

    test('should be equal when all properties are the same', () {
      final anotherEntity = ItemEntity(
        itemId: 'item-123',
        reportedBy: 'user-1',
        claimedBy: 'user-2',
        category: 'electronics',
        itemName: 'Lost Phone',
        description: 'Black iPhone found near library',
        type: ItemType.lost,
        location: 'Library',
        media: 'https://example.com/photo.jpg',
        mediaType: 'image',
        isClaimed: true,
        status: 'active',
        createdAt: tCreatedAt,
        updatedAt: tUpdatedAt,
      );

      expect(tItemEntity, equals(anotherEntity));
    });

    test('isClaimed should default to false', () {
      const entity = ItemEntity(
        itemName: 'Test Item',
        type: ItemType.lost,
        location: 'Somewhere',
      );

      expect(entity.isClaimed, false);
    });

    group('isVideo', () {
      test('should return true when mediaType is video', () {
        const entity = ItemEntity(
          itemName: 'Test Item',
          type: ItemType.lost,
          location: 'Lab',
          mediaType: 'video',
        );

        expect(entity.isVideo, true);
      });

      test('should return true when media has mp4 extension', () {
        const entity = ItemEntity(
          itemName: 'Test Item',
          type: ItemType.lost,
          location: 'Lab',
          media: 'https://example.com/video.mp4',
        );

        expect(entity.isVideo, true);
      });

      test('should return true when media has mov extension', () {
        const entity = ItemEntity(
          itemName: 'Test Item',
          type: ItemType.lost,
          location: 'Lab',
          media: 'https://example.com/clip.mov',
        );

        expect(entity.isVideo, true);
      });

      test('should return true when media has avi extension', () {
        const entity = ItemEntity(
          itemName: 'Test Item',
          type: ItemType.lost,
          location: 'Lab',
          media: 'https://example.com/clip.avi',
        );

        expect(entity.isVideo, true);
      });

      test('should return true when media has mkv extension', () {
        const entity = ItemEntity(
          itemName: 'Test Item',
          type: ItemType.lost,
          location: 'Lab',
          media: 'https://example.com/clip.mkv',
        );

        expect(entity.isVideo, true);
      });

      test('should return true when media has webm extension', () {
        const entity = ItemEntity(
          itemName: 'Test Item',
          type: ItemType.lost,
          location: 'Lab',
          media: 'https://example.com/clip.webm',
        );

        expect(entity.isVideo, true);
      });

      test('should return false when media is null and mediaType is not video',
          () {
        const entity = ItemEntity(
          itemName: 'Test Item',
          type: ItemType.lost,
          location: 'Lab',
        );

        expect(entity.isVideo, false);
      });

      test('should return false when media has image extension', () {
        const entity = ItemEntity(
          itemName: 'Test Item',
          type: ItemType.lost,
          location: 'Lab',
          media: 'https://example.com/photo.jpg',
        );

        expect(entity.isVideo, false);
      });

      test('should return false when media has png extension', () {
        const entity = ItemEntity(
          itemName: 'Test Item',
          type: ItemType.lost,
          location: 'Lab',
          media: 'https://example.com/photo.png',
        );

        expect(entity.isVideo, false);
      });
    });
  });
}
