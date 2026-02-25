import 'dart:io';

import 'package:lost_n_found/features/item/data/models/item_api_model.dart';
import 'package:lost_n_found/features/item/data/models/item_hive_model.dart';

abstract interface class IItemLocalDataSource {
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

abstract interface class IItemRemoteDataSource {
  Future<String> uploadPhoto(File photo);
  Future<String> uploadVideo(File video);
  Future<ItemApiModel> createItem(ItemApiModel item);
  Future<List<ItemApiModel>> getAllItems();
  Future<ItemApiModel> getItemById(String itemId);
  Future<List<ItemApiModel>> getItemsByUser(String userId);
  Future<List<ItemApiModel>> getLostItems();
  Future<List<ItemApiModel>> getFoundItems();
  Future<List<ItemApiModel>> getItemsByCategory(String categoryId);
  Future<bool> updateItem(ItemApiModel item);
  Future<bool> deleteItem(String itemId);
}
