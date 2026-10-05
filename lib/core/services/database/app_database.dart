import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/core/constants/database_constant.dart';
import 'package:lost_n_found/core/services/database/tables/auth_table.dart';
import 'package:lost_n_found/core/services/database/tables/batch_table.dart';
import 'package:lost_n_found/core/services/database/tables/category_table.dart';
import 'package:lost_n_found/core/services/database/tables/item_table.dart';
import 'package:uuid/uuid.dart';

part 'app_database.g.dart';

// The database is opened asynchronously, so main.dart creates the instance and
// overrides this provider -- same pattern as sharedPreferencesProvider.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError('AppDatabase must be overridden in main.dart');
});

@DriftDatabase(tables: [AuthTable, BatchTable, CategoryTable, ItemTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: DatabaseConstant.dbName));

  /// In-memory database for tests. Pass `NativeDatabase.memory()`.
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  // ======================= Seed Data =========================

  Future<void> insertBatchDummyData() async {
    final existing = await select(batchTable).get();
    if (existing.isNotEmpty) {
      return;
    }

    const batchNames = ['35A', '35B', '35C', '36A', '36B', '37A', '38B'];
    final dummyBatches = batchNames
        .map(
          (name) => BatchModel(
            batchId: const Uuid().v4(),
            batchName: name,
            status: 'active',
          ),
        )
        .toList();

    await batch((b) => b.insertAll(batchTable, dummyBatches));
  }

  Future<void> insertCategoryDummyData() async {
    final existing = await select(categoryTable).get();
    if (existing.isNotEmpty) {
      return;
    }

    const categories = {
      'Electronics': 'Phones, laptops, tablets, etc.',
      'Personal': 'Personal belongings',
      'Accessories': 'Watches, jewelry, etc.',
      'Documents': 'IDs, certificates, papers',
      'Keys': 'House keys, car keys, etc.',
      'Bags': 'Backpacks, handbags, wallets',
      'Other': 'Miscellaneous items',
    };
    final dummyCategories = categories.entries
        .map(
          (entry) => CategoryModel(
            categoryId: const Uuid().v4(),
            name: entry.key,
            description: entry.value,
            status: 'active',
          ),
        )
        .toList();

    await batch((b) => b.insertAll(categoryTable, dummyCategories));
  }

  // ======================= Batch Queries =========================

  Future<BatchModel> createBatch(BatchModel batchModel) async {
    await into(batchTable).insertOnConflictUpdate(batchModel);
    return batchModel;
  }

  Future<List<BatchModel>> getAllBatches() => select(batchTable).get();

  Future<BatchModel?> getBatchById(String batchId) =>
      (select(batchTable)..where((t) => t.batchId.equals(batchId)))
          .getSingleOrNull();

  Future<bool> updateBatch(BatchModel batch) async {
    final rows = await (update(
      batchTable,
    )..where((t) => t.batchId.equals(batch.batchId))).write(batch);
    return rows > 0;
  }

  Future<void> deleteBatch(String batchId) async {
    await (delete(batchTable)..where((t) => t.batchId.equals(batchId))).go();
  }

  // ======================= Auth Queries =========================

  // Register user
  Future<AuthModel> register(AuthModel user) async {
    await into(authTable).insertOnConflictUpdate(user);
    return user;
  }

  // Login - find user by email and password
  Future<AuthModel?> login(String email, String password) =>
      (select(authTable)
            ..where((t) => t.email.equals(email) & t.password.equals(password))
            ..limit(1))
          .getSingleOrNull();

  // Get user by ID
  Future<AuthModel?> getUserById(String authId) =>
      (select(authTable)..where((t) => t.authId.equals(authId)))
          .getSingleOrNull();

  // Get user by email
  Future<AuthModel?> getUserByEmail(String email) =>
      (select(authTable)
            ..where((t) => t.email.equals(email))
            ..limit(1))
          .getSingleOrNull();

  // Update user
  Future<bool> updateUser(AuthModel user) async {
    final rows = await (update(
      authTable,
    )..where((t) => t.authId.equals(user.authId))).write(user);
    return rows > 0;
  }

  // Delete user
  Future<void> deleteUser(String authId) async {
    await (delete(authTable)..where((t) => t.authId.equals(authId))).go();
  }

  // ======================= Item Queries =========================

  Future<ItemModel> createItem(ItemModel item) async {
    await into(itemTable).insertOnConflictUpdate(item);
    return item;
  }

  Future<List<ItemModel>> getAllItems() => select(itemTable).get();

  Future<ItemModel?> getItemById(String itemId) =>
      (select(itemTable)..where((t) => t.itemId.equals(itemId)))
          .getSingleOrNull();

  Future<List<ItemModel>> getItemsByUser(String userId) =>
      (select(itemTable)..where((t) => t.reportedBy.equals(userId))).get();

  Future<List<ItemModel>> getLostItems() =>
      (select(itemTable)..where((t) => t.type.equals('lost'))).get();

  Future<List<ItemModel>> getFoundItems() =>
      (select(itemTable)..where((t) => t.type.equals('found'))).get();

  Future<List<ItemModel>> getItemsByCategory(String categoryId) =>
      (select(itemTable)..where((t) => t.categoryId.equals(categoryId))).get();

  Future<bool> updateItem(ItemModel item) async {
    final rows = await (update(
      itemTable,
    )..where((t) => t.itemId.equals(item.itemId))).write(item);
    return rows > 0;
  }

  Future<void> deleteItem(String itemId) async {
    await (delete(itemTable)..where((t) => t.itemId.equals(itemId))).go();
  }

  // ======================= Category Queries =========================

  Future<CategoryModel> createCategory(CategoryModel category) async {
    await into(categoryTable).insertOnConflictUpdate(category);
    return category;
  }

  Future<List<CategoryModel>> getAllCategories() => select(categoryTable).get();

  Future<CategoryModel?> getCategoryById(String categoryId) =>
      (select(categoryTable)..where((t) => t.categoryId.equals(categoryId)))
          .getSingleOrNull();

  Future<bool> updateCategory(CategoryModel category) async {
    final rows = await (update(
      categoryTable,
    )..where((t) => t.categoryId.equals(category.categoryId))).write(category);
    return rows > 0;
  }

  Future<void> deleteCategory(String categoryId) async {
    await (delete(
      categoryTable,
    )..where((t) => t.categoryId.equals(categoryId))).go();
  }
}
