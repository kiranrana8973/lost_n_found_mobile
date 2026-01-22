import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/features/item/domain/entities/item_entity.dart';
import 'package:lost_n_found/features/item/domain/usecases/create_item_usecase.dart';
import 'package:lost_n_found/features/item/domain/usecases/delete_item_usecase.dart';
import 'package:lost_n_found/features/item/domain/usecases/get_all_items_usecase.dart';
import 'package:lost_n_found/features/item/domain/usecases/get_item_by_id_usecase.dart';
import 'package:lost_n_found/features/item/domain/usecases/get_items_by_user_usecase.dart';
import 'package:lost_n_found/features/item/domain/usecases/update_item_usecase.dart';
import 'package:lost_n_found/features/item/presentation/state/item_state.dart';

final itemViewModelProvider = NotifierProvider<ItemViewModel, ItemState>(
  ItemViewModel.new,
);

class ItemViewModel extends Notifier<ItemState> {
  late final GetAllItemsUsecase _getAllItemsUsecase;
  late final GetItemByIdUsecase _getItemByIdUsecase;
  late final GetItemsByUserUsecase _getItemsByUserUsecase;
  late final CreateItemUsecase _createItemUsecase;
  late final UpdateItemUsecase _updateItemUsecase;
  late final DeleteItemUsecase _deleteItemUsecase;

  @override
  ItemState build() {
    _getAllItemsUsecase = ref.read(getAllItemsUsecaseProvider);
    _getItemByIdUsecase = ref.read(getItemByIdUsecaseProvider);
    _getItemsByUserUsecase = ref.read(getItemsByUserUsecaseProvider);
    _createItemUsecase = ref.read(createItemUsecaseProvider);
    _updateItemUsecase = ref.read(updateItemUsecaseProvider);
    _deleteItemUsecase = ref.read(deleteItemUsecaseProvider);
    return const ItemState();
  }

  Future<void> getAllItems() async {
    state = state.copyWith(status: ItemStatus.loading);

    final result = await _getAllItemsUsecase();

    result.fold(
      (failure) => state = state.copyWith(
        status: ItemStatus.error,
        errorMessage: failure.message,
      ),
      (items) {
        final lostItems = items
            .where((item) => item.type == ItemType.lost)
            .toList();
        final foundItems = items
            .where((item) => item.type == ItemType.found)
            .toList();
        state = state.copyWith(
          status: ItemStatus.loaded,
          items: items,
          lostItems: lostItems,
          foundItems: foundItems,
        );
      },
    );
  }

  Future<void> getItemById(String itemId) async {
    state = state.copyWith(status: ItemStatus.loading);

    final result = await _getItemByIdUsecase(GetItemByIdParams(itemId: itemId));

    result.fold(
      (failure) => state = state.copyWith(
        status: ItemStatus.error,
        errorMessage: failure.message,
      ),
      (item) =>
          state = state.copyWith(status: ItemStatus.loaded, selectedItem: item),
    );
  }

  Future<void> getMyItems(String userId) async {
    state = state.copyWith(status: ItemStatus.loading);

    final result = await _getItemsByUserUsecase(
      GetItemsByUserParams(userId: userId),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: ItemStatus.error,
        errorMessage: failure.message,
      ),
      (items) {
        final myLostItems = items
            .where((item) => item.type == ItemType.lost)
            .toList();
        final myFoundItems = items
            .where((item) => item.type == ItemType.found)
            .toList();
        state = state.copyWith(
          status: ItemStatus.loaded,
          myLostItems: myLostItems,
          myFoundItems: myFoundItems,
        );
      },
    );
  }

  Future<void> createItem({
    required String itemName,
    String? description,
    String? categoryId,
    required String location,
    required ItemType type,
    String? reportedBy,
    String? media,
    String? mediaType,
  }) async {
    state = state.copyWith(status: ItemStatus.loading);

    final result = await _createItemUsecase(
      CreateItemParams(
        itemName: itemName,
        description: description,
        categoryId: categoryId,
        location: location,
        type: type,
        reportedBy: reportedBy,
        media: media,
        mediaType: mediaType,
      ),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: ItemStatus.error,
        errorMessage: failure.message,
      ),
      (success) {
        state = state.copyWith(status: ItemStatus.created);
        getAllItems();
      },
    );
  }

  Future<void> updateItem({
    required String itemId,
    required String itemName,
    String? description,
    String? categoryId,
    required String location,
    required ItemType type,
    String? claimedBy,
    String? media,
    String? mediaType,
    bool? isClaimed,
    String? status,
  }) async {
    state = state.copyWith(status: ItemStatus.loading);

    final result = await _updateItemUsecase(
      UpdateItemParams(
        itemId: itemId,
        itemName: itemName,
        description: description,
        categoryId: categoryId,
        location: location,
        type: type,
        claimedBy: claimedBy,
        media: media,
        mediaType: mediaType,
        isClaimed: isClaimed,
        status: status,
      ),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: ItemStatus.error,
        errorMessage: failure.message,
      ),
      (success) {
        state = state.copyWith(status: ItemStatus.updated);
        getAllItems();
      },
    );
  }

  Future<void> deleteItem(String itemId) async {
    state = state.copyWith(status: ItemStatus.loading);

    final result = await _deleteItemUsecase(DeleteItemParams(itemId: itemId));

    result.fold(
      (failure) => state = state.copyWith(
        status: ItemStatus.error,
        errorMessage: failure.message,
      ),
      (success) {
        state = state.copyWith(status: ItemStatus.deleted);
        getAllItems();
      },
    );
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  void clearSelectedItem() {
    state = state.copyWith(selectedItem: null);
  }
}
