import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/core/services/database/app_database.dart';
import 'package:lost_n_found/features/item/data/datasources/item_datasource.dart';

final itemLocalDatasourceProvider = Provider<ItemLocalDatasource>((ref) {
  final appDatabase = ref.read(appDatabaseProvider);
  return ItemLocalDatasource(appDatabase: appDatabase);
});

class ItemLocalDatasource implements IItemDataSource {
  final AppDatabase _db;

  ItemLocalDatasource({required AppDatabase appDatabase})
      : _db = appDatabase;

  @override
  Future<bool> createItem(ItemModel item) async {
    try {
      await _db.createItem(item);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteItem(String itemId) async {
    try {
      await _db.deleteItem(itemId);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<ItemModel>> getAllItems() async {
    try {
      return await _db.getAllItems();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<ItemModel?> getItemById(String itemId) async {
    try {
      return await _db.getItemById(itemId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<ItemModel>> getItemsByUser(String userId) async {
    try {
      return await _db.getItemsByUser(userId);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<ItemModel>> getLostItems() async {
    try {
      return await _db.getLostItems();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<ItemModel>> getFoundItems() async {
    try {
      return await _db.getFoundItems();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<ItemModel>> getItemsByCategory(String categoryId) async {
    try {
      return await _db.getItemsByCategory(categoryId);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<bool> updateItem(ItemModel item) async {
    try {
      await _db.updateItem(item);
      return true;
    } catch (e) {
      return false;
    }
  }
}
