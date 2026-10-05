import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/core/services/database/app_database.dart';
import 'package:lost_n_found/features/auth/data/models/auth_model.dart';
import 'package:lost_n_found/features/auth/domain/entities/auth_entity.dart';
import 'package:lost_n_found/features/batch/data/models/batch_model.dart';
import 'package:lost_n_found/features/batch/domain/entities/batch_entity.dart';
import 'package:lost_n_found/features/category/data/models/category_model.dart';
import 'package:lost_n_found/features/category/domain/entities/category_entity.dart';
import 'package:lost_n_found/features/item/data/models/item_model.dart';
import 'package:lost_n_found/features/item/domain/entities/item_entity.dart';

/// These run against an in-memory SQLite database, so they are fast and need
/// no device or emulator.
void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase.forTesting(NativeDatabase.memory()));
  tearDown(() => db.close());

  AuthModel buildUser({String email = 'k@example.com', String? authId}) {
    return AuthEntity(
      authId: authId,
      fullName: 'Kiran Rana',
      email: email,
      username: 'kiran',
      password: 'secret',
      phoneNumber: '9800000000',
    ).toModel();
  }

  group('seed data', () {
    test('inserts the reference batches and categories', () async {
      await db.insertBatchDummyData();
      await db.insertCategoryDummyData();

      expect(await db.getAllBatches(), hasLength(7));
      expect(await db.getAllCategories(), hasLength(7));
    });

    test('is idempotent across app launches', () async {
      await db.insertBatchDummyData();
      await db.insertCategoryDummyData();
      await db.insertBatchDummyData();
      await db.insertCategoryDummyData();

      expect(await db.getAllBatches(), hasLength(7));
      expect(await db.getAllCategories(), hasLength(7));
    });
  });

  group('auth', () {
    test('register then log in with the right credentials', () async {
      final user = await db.register(buildUser());

      expect(await db.login('k@example.com', 'secret'), isNotNull);
      expect(await db.getUserById(user.authId), isNotNull);
    });

    test('login rejects a wrong password and an unknown email', () async {
      await db.register(buildUser());

      expect(await db.login('k@example.com', 'wrong'), isNull);
      expect(await db.login('nobody@example.com', 'secret'), isNull);
    });

    test('getUserByEmail finds the account', () async {
      await db.register(buildUser());

      final found = await db.getUserByEmail('k@example.com');
      expect(found, isNotNull);
      expect(found!.fullName, 'Kiran Rana');
      expect(found.phoneNumber, '9800000000');
    });

    test('updateUser writes changes and reports success', () async {
      final user = await db.register(buildUser());

      final ok = await db.updateUser(user.copyWith(fullName: 'Kiran B. Rana'));

      expect(ok, isTrue);
      expect((await db.getUserById(user.authId))!.fullName, 'Kiran B. Rana');
    });

    test('updateUser reports failure for an id that does not exist', () async {
      final user = await db.register(buildUser());

      expect(
        await db.updateUser(user.copyWith(authId: 'no-such-id')),
        isFalse,
        reason: 'must match the old containsKey behaviour',
      );
    });

    test('deleteUser removes the account', () async {
      final user = await db.register(buildUser());

      await db.deleteUser(user.authId);

      expect(await db.getUserById(user.authId), isNull);
    });

    test('a duplicate email is rejected by the unique index', () async {
      await db.register(buildUser());

      // Same email, different primary key -> the database must refuse it.
      await expectLater(
        db.register(buildUser(authId: 'another-id')),
        throwsA(isException),
      );
      expect(await db.getAllCategories(), isEmpty); // unrelated table untouched
    });
  });

  group('items', () {
    ItemModel buildItem({
      required String name,
      required ItemType type,
      String? reportedBy,
      String? categoryId,
    }) {
      return ItemEntity(
        itemName: name,
        type: type,
        location: 'Library',
        reportedBy: reportedBy,
        categoryId: categoryId,
      ).toModel();
    }

    test('filters by lost and found', () async {
      await db.createItem(buildItem(name: 'Backpack', type: ItemType.lost));
      await db.createItem(buildItem(name: 'Umbrella', type: ItemType.found));

      expect((await db.getLostItems()).single.itemName, 'Backpack');
      expect((await db.getFoundItems()).single.itemName, 'Umbrella');
      expect(await db.getAllItems(), hasLength(2));
    });

    test('filters by reporter and by category', () async {
      await db.createItem(
        buildItem(
          name: 'Backpack',
          type: ItemType.lost,
          reportedBy: 'user-1',
          categoryId: 'cat-1',
        ),
      );
      await db.createItem(
        buildItem(
          name: 'Umbrella',
          type: ItemType.found,
          reportedBy: 'user-2',
          categoryId: 'cat-1',
        ),
      );

      expect((await db.getItemsByUser('user-1')).single.itemName, 'Backpack');
      expect(await db.getItemsByCategory('cat-1'), hasLength(2));
      expect(await db.getItemsByUser('nobody'), isEmpty);
    });

    test('defaults a new item to unclaimed and active', () async {
      final item = await db.createItem(
        buildItem(name: 'Backpack', type: ItemType.lost),
      );

      final stored = await db.getItemById(item.itemId);
      expect(stored!.isClaimed, isFalse);
      expect(stored.status, 'active');
    });

    test('claiming an item persists', () async {
      final item = await db.createItem(
        buildItem(name: 'Backpack', type: ItemType.lost),
      );

      expect(await db.updateItem(item.copyWith(isClaimed: true)), isTrue);
      expect((await db.getItemById(item.itemId))!.isClaimed, isTrue);
    });

    test('deleteItem removes only that item', () async {
      final lost = await db.createItem(
        buildItem(name: 'Backpack', type: ItemType.lost),
      );
      await db.createItem(buildItem(name: 'Umbrella', type: ItemType.found));

      await db.deleteItem(lost.itemId);

      expect(await db.getItemById(lost.itemId), isNull);
      expect(await db.getAllItems(), hasLength(1));
    });
  });

  group('batches and categories', () {
    test('updateBatch keeps the same row and id', () async {
      final created = await db.createBatch(
        const BatchEntity(batchName: '35A').toModel(),
      );

      final ok = await db.updateBatch(
        BatchEntity(
          batchId: created.batchId,
          batchName: '35A-renamed',
          status: 'active',
        ).toModel(),
      );

      expect(ok, isTrue);
      final all = await db.getAllBatches();
      expect(all, hasLength(1), reason: 'update must not insert a new row');
      expect(all.single.batchId, created.batchId);
      expect(all.single.batchName, '35A-renamed');
    });

    test('getBatchById returns null when missing', () async {
      expect(await db.getBatchById('no-such-id'), isNull);
    });

    test('category create, update and delete', () async {
      final created = await db.createCategory(
        const CategoryEntity(name: 'Electronics', description: 'Phones').toModel(),
      );

      expect(created.status, 'active');
      expect(
        await db.updateCategory(created.copyWith(name: 'Gadgets')),
        isTrue,
      );
      expect((await db.getCategoryById(created.categoryId))!.name, 'Gadgets');

      await db.deleteCategory(created.categoryId);
      expect(await db.getCategoryById(created.categoryId), isNull);
    });
  });

  group('entity mapping', () {
    test('item survives a full entity -> model -> entity round trip', () async {
      const original = ItemEntity(
        itemId: 'item-1',
        reportedBy: 'user-1',
        claimedBy: 'user-2',
        categoryId: 'cat-1',
        itemName: 'Black backpack',
        description: 'Has a laptop inside',
        type: ItemType.lost,
        location: 'Library',
        media: '/tmp/photo.jpg',
        mediaType: 'image',
        isClaimed: true,
        status: 'active',
      );

      await db.createItem(original.toModel());
      final restored = (await db.getItemById('item-1'))!.toEntity();

      expect(restored, original);
    });

    test('toModel generates an id when the entity has none', () async {
      final model = const BatchEntity(batchName: '35A').toModel();

      expect(model.batchId, isNotEmpty);
      expect(model.status, 'active');
    });

    test('list mappers convert every row', () async {
      await db.insertBatchDummyData();

      final entities = (await db.getAllBatches()).toEntityList();

      expect(entities, hasLength(7));
      expect(entities.map((e) => e.batchName), contains('35A'));
    });
  });
}
