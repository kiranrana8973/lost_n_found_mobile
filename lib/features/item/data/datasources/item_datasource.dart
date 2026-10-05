import 'package:lost_n_found/features/item/data/models/item_model.dart';

abstract interface class IItemDataSource {
  Future<List<ItemModel>> getAllItems();
  Future<List<ItemModel>> getItemsByUser(String userId);
  Future<List<ItemModel>> getLostItems();
  Future<List<ItemModel>> getFoundItems();
  Future<List<ItemModel>> getItemsByCategory(String categoryId);
  Future<ItemModel?> getItemById(String itemId);
  Future<bool> createItem(ItemModel item);
  Future<bool> updateItem(ItemModel item);
  Future<bool> deleteItem(String itemId);
}
