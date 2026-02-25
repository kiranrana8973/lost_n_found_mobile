import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:lost_n_found/core/constants/hive_table_constant.dart';
import 'package:lost_n_found/features/auth/data/models/auth_hive_model.dart';
import 'package:lost_n_found/features/batch/data/models/batch_hive_model.dart';
import 'package:lost_n_found/features/category/data/models/category_hive_model.dart';
import 'package:lost_n_found/features/item/data/models/item_hive_model.dart';
import 'package:path_provider/path_provider.dart';

final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService();
});

// ─────────────────────────────────────────────────────────────────────────────
// Generic Hive box wrapper — eliminates CRUD boilerplate
// ─────────────────────────────────────────────────────────────────────────────

class _BoxOps<T extends HiveObject> {
  final String _boxName;

  _BoxOps(this._boxName);

  Box<T> get _box => Hive.box<T>(_boxName);

  Future<T> put(String key, T value) async {
    await _box.put(key, value);
    return value;
  }

  T? get(String key) => _box.get(key);

  List<T> getAll() => _box.values.toList();

  List<T> where(bool Function(T) test) => _box.values.where(test).toList();

  T? firstWhere(bool Function(T) test) {
    for (final value in _box.values) {
      if (test(value)) return value;
    }
    return null;
  }

  Future<bool> update(String key, T value) async {
    if (!_box.containsKey(key)) return false;
    await _box.put(key, value);
    return true;
  }

  Future<void> delete(String key) => _box.delete(key);

  /// Atomic cache replace — clear + bulk insert in one go.
  Future<void> replaceAll(Map<String, T> entries) async {
    await _box.clear();
    if (entries.isNotEmpty) {
      await _box.putAll(entries);
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Adapter registration table — single source of truth
// ─────────────────────────────────────────────────────────────────────────────

typedef _AdapterEntry = ({int typeId, TypeAdapter adapter, String boxName});

List<_AdapterEntry> _buildAdapterTable() => [
  (
    typeId: HiveTableConstant.batchTypeId,
    adapter: BatchHiveModelAdapter(),
    boxName: HiveTableConstant.batchTable,
  ),
  (
    typeId: HiveTableConstant.studentTypeId,
    adapter: AuthHiveModelAdapter(),
    boxName: HiveTableConstant.studentTable,
  ),
  (
    typeId: HiveTableConstant.itemTypeId,
    adapter: ItemHiveModelAdapter(),
    boxName: HiveTableConstant.itemTable,
  ),
  (
    typeId: HiveTableConstant.categoryTypeId,
    adapter: CategoryHiveModelAdapter(),
    boxName: HiveTableConstant.categoryTable,
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// HiveService — central Hive facade
// ─────────────────────────────────────────────────────────────────────────────

class HiveService {
  // Typed box wrappers — lazy access, no field storage needed
  final _batches = _BoxOps<BatchHiveModel>(HiveTableConstant.batchTable);
  final _students = _BoxOps<AuthHiveModel>(HiveTableConstant.studentTable);
  final _items = _BoxOps<ItemHiveModel>(HiveTableConstant.itemTable);
  final _categories = _BoxOps<CategoryHiveModel>(
    HiveTableConstant.categoryTable,
  );

  /// Call once in main.dart before runApp().
  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    Hive.init('${directory.path}/${HiveTableConstant.dbName}');

    for (final entry in _buildAdapterTable()) {
      if (!Hive.isAdapterRegistered(entry.typeId)) {
        Hive.registerAdapter(entry.adapter);
      }
    }

    await Future.wait([
      Hive.openBox<BatchHiveModel>(HiveTableConstant.batchTable),
      Hive.openBox<AuthHiveModel>(HiveTableConstant.studentTable),
      Hive.openBox<ItemHiveModel>(HiveTableConstant.itemTable),
      Hive.openBox<CategoryHiveModel>(HiveTableConstant.categoryTable),
    ]);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Batch
  // ═══════════════════════════════════════════════════════════════════════════

  Future<BatchHiveModel> createBatch(BatchHiveModel batch) =>
      _batches.put(batch.batchId!, batch);

  List<BatchHiveModel> getAllBatches() => _batches.getAll();

  BatchHiveModel? getBatchById(String batchId) => _batches.get(batchId);

  Future<bool> updateBatch(BatchHiveModel batch) =>
      _batches.update(batch.batchId!, batch);

  Future<void> deleteBatch(String batchId) => _batches.delete(batchId);

  Future<void> cacheAllBatches(List<BatchHiveModel> batches) =>
      _batches.replaceAll({for (final b in batches) b.batchId!: b});

  // ═══════════════════════════════════════════════════════════════════════════
  // Auth (Student)
  // ═══════════════════════════════════════════════════════════════════════════

  Future<AuthHiveModel> register(AuthHiveModel user) =>
      _students.put(user.authId!, user);

  AuthHiveModel? login(String email, String password) =>
      _students.firstWhere((u) => u.email == email && u.password == password);

  AuthHiveModel? getUserById(String authId) => _students.get(authId);

  AuthHiveModel? getUserByEmail(String email) =>
      _students.firstWhere((u) => u.email == email);

  Future<bool> updateUser(AuthHiveModel user) =>
      _students.update(user.authId!, user);

  Future<void> deleteUser(String authId) => _students.delete(authId);

  // ═══════════════════════════════════════════════════════════════════════════
  // Item
  // ═══════════════════════════════════════════════════════════════════════════

  Future<ItemHiveModel> createItem(ItemHiveModel item) =>
      _items.put(item.itemId!, item);

  List<ItemHiveModel> getAllItems() => _items.getAll();

  ItemHiveModel? getItemById(String itemId) => _items.get(itemId);

  List<ItemHiveModel> getItemsByUser(String userId) =>
      _items.where((i) => i.reportedBy == userId);

  List<ItemHiveModel> getLostItems() => _items.where((i) => i.type == 'lost');

  List<ItemHiveModel> getFoundItems() => _items.where((i) => i.type == 'found');

  List<ItemHiveModel> getItemsByCategory(String categoryId) =>
      _items.where((i) => i.category == categoryId);

  Future<bool> updateItem(ItemHiveModel item) =>
      _items.update(item.itemId!, item);

  Future<void> deleteItem(String itemId) => _items.delete(itemId);

  Future<void> cacheAllItems(List<ItemHiveModel> items) =>
      _items.replaceAll({for (final i in items) i.itemId!: i});

  // ═══════════════════════════════════════════════════════════════════════════
  // Category
  // ═══════════════════════════════════════════════════════════════════════════

  Future<CategoryHiveModel> createCategory(CategoryHiveModel category) =>
      _categories.put(category.categoryId!, category);

  List<CategoryHiveModel> getAllCategories() => _categories.getAll();

  CategoryHiveModel? getCategoryById(String categoryId) =>
      _categories.get(categoryId);

  Future<bool> updateCategory(CategoryHiveModel category) =>
      _categories.update(category.categoryId!, category);

  Future<void> deleteCategory(String categoryId) =>
      _categories.delete(categoryId);

  Future<void> cacheAllCategories(List<CategoryHiveModel> categories) =>
      _categories.replaceAll({for (final c in categories) c.categoryId!: c});
}
