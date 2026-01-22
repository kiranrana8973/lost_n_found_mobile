import 'package:equatable/equatable.dart';
import 'package:lost_n_found/features/item/domain/entities/item_entity.dart';

enum ItemStatus { initial, loading, loaded, error, created, updated, deleted }

class ItemState extends Equatable {
  final ItemStatus status;
  final List<ItemEntity> items;
  final List<ItemEntity> lostItems;
  final List<ItemEntity> foundItems;
  final List<ItemEntity> myLostItems;
  final List<ItemEntity> myFoundItems;
  final ItemEntity? selectedItem;
  final String? errorMessage;

  const ItemState({
    this.status = ItemStatus.initial,
    this.items = const [],
    this.lostItems = const [],
    this.foundItems = const [],
    this.myLostItems = const [],
    this.myFoundItems = const [],
    this.selectedItem,
    this.errorMessage,
  });

  ItemState copyWith({
    ItemStatus? status,
    List<ItemEntity>? items,
    List<ItemEntity>? lostItems,
    List<ItemEntity>? foundItems,
    List<ItemEntity>? myLostItems,
    List<ItemEntity>? myFoundItems,
    ItemEntity? selectedItem,
    String? errorMessage,
  }) {
    return ItemState(
      status: status ?? this.status,
      items: items ?? this.items,
      lostItems: lostItems ?? this.lostItems,
      foundItems: foundItems ?? this.foundItems,
      myLostItems: myLostItems ?? this.myLostItems,
      myFoundItems: myFoundItems ?? this.myFoundItems,
      selectedItem: selectedItem ?? this.selectedItem,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, items, lostItems, foundItems, myLostItems, myFoundItems, selectedItem, errorMessage];
}
