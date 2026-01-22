import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/core/services/hive/hive_service.dart';
import 'package:lost_n_found/features/item/data/datasources/item_datasource.dart';
import 'package:lost_n_found/features/item/data/models/item_hive_model.dart';

final itemLocalDatasourceProvider = Provider<ItemLocalDatasource>((ref) {
  final hiveService = ref.read(hiveServiceProvider);
  return ItemLocalDatasource(hiveService: hiveService);
});

class ItemLocalDatasource implements IItemDataSource {
  final HiveService _hiveService;

  ItemLocalDatasource({required HiveService hiveService})
      : _hiveService = hiveService;

  @override
  Future<bool> createItem(ItemHiveModel item) async {
    try {
      await _hiveService.createItem(item);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteItem(String itemId) async {
    try {
      await _hiveService.deleteItem(itemId);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<ItemHiveModel>> getAllItems() async {
    try {
      return _hiveService.getAllItems();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<ItemHiveModel?> getItemById(String itemId) async {
    try {
      return _hiveService.getItemById(itemId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<ItemHiveModel>> getItemsByUser(String userId) async {
    try {
      return _hiveService.getItemsByUser(userId);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<ItemHiveModel>> getLostItems() async {
    try {
      return _hiveService.getLostItems();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<ItemHiveModel>> getFoundItems() async {
    try {
      return _hiveService.getFoundItems();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<ItemHiveModel>> getItemsByCategory(String categoryId) async {
    try {
      return _hiveService.getItemsByCategory(categoryId);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<bool> updateItem(ItemHiveModel item) async {
    try {
      await _hiveService.updateItem(item);
      return true;
    } catch (e) {
      return false;
    }
  }
}
