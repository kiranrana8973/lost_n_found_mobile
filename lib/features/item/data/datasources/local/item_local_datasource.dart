import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/core/constants/hive_table_constant.dart';
import 'package:lost_n_found/core/services/hive/hive_box.dart';
import 'package:lost_n_found/features/item/data/datasources/item_datasource.dart';
import 'package:lost_n_found/features/item/data/models/item_hive_model.dart';

final itemLocalDatasourceProvider = Provider<ItemLocalDatasource>((ref) {
  return ItemLocalDatasource();
});

class ItemLocalDatasource implements IItemLocalDataSource {
  final HiveBox<ItemHiveModel> _box;

  ItemLocalDatasource()
    : _box = HiveBox<ItemHiveModel>(HiveTableConstant.itemTable);

  @override
  Future<bool> createItem(ItemHiveModel item) async {
    try {
      await _box.put(item.itemId!, item);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteItem(String itemId) async {
    try {
      await _box.delete(itemId);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<ItemHiveModel>> getAllItems() async {
    try {
      return _box.getAll();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<ItemHiveModel?> getItemById(String itemId) async {
    try {
      return _box.get(itemId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<ItemHiveModel>> getItemsByUser(String userId) async {
    try {
      return _box.where((i) => i.reportedBy == userId);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<ItemHiveModel>> getLostItems() async {
    try {
      return _box.where((i) => i.type == 'lost');
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<ItemHiveModel>> getFoundItems() async {
    try {
      return _box.where((i) => i.type == 'found');
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<ItemHiveModel>> getItemsByCategory(String categoryId) async {
    try {
      return _box.where((i) => i.category == categoryId);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<bool> updateItem(ItemHiveModel item) async {
    try {
      return await _box.update(item.itemId!, item);
    } catch (e) {
      return false;
    }
  }

  Future<void> cacheAllItems(List<ItemHiveModel> items) async {
    await _box.replaceAll({for (final i in items) i.itemId!: i});
  }
}
