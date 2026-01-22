import 'package:lost_n_found/features/item/data/models/item_hive_model.dart';

abstract interface class IItemDataSource {
  Future<List<ItemHiveModel>> getAllItems();
  Future<List<ItemHiveModel>> getItemsByUser(String userId);
  Future<List<ItemHiveModel>> getLostItems();
  Future<List<ItemHiveModel>> getFoundItems();
  Future<List<ItemHiveModel>> getItemsByCategory(String categoryId);
  Future<ItemHiveModel?> getItemById(String itemId);
  Future<bool> createItem(ItemHiveModel item);
  Future<bool> updateItem(ItemHiveModel item);
  Future<bool> deleteItem(String itemId);
}
