import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/item_entity.dart';
import '../../domain/usecases/create_item_usecase.dart';
import '../../domain/usecases/delete_item_usecase.dart';
import '../../domain/usecases/get_all_items_usecase.dart';
import '../../domain/usecases/get_item_by_id_usecase.dart';
import '../../domain/usecases/get_items_by_user_usecase.dart';
import '../../domain/usecases/update_item_usecase.dart';
import '../../domain/usecases/upload_photo_usecase.dart';
import '../../domain/usecases/upload_video_usecase.dart';
import '../state/item_state.dart';
import 'item_event.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  final GetAllItemsUsecase _getAllItemsUsecase;
  final GetItemByIdUsecase _getItemByIdUsecase;
  final GetItemsByUserUsecase _getItemsByUserUsecase;
  final CreateItemUsecase _createItemUsecase;
  final UpdateItemUsecase _updateItemUsecase;
  final DeleteItemUsecase _deleteItemUsecase;
  final UploadPhotoUsecase _uploadPhotoUsecase;
  final UploadVideoUsecase _uploadVideoUsecase;

  ItemBloc({
    required GetAllItemsUsecase getAllItemsUsecase,
    required GetItemByIdUsecase getItemByIdUsecase,
    required GetItemsByUserUsecase getItemsByUserUsecase,
    required CreateItemUsecase createItemUsecase,
    required UpdateItemUsecase updateItemUsecase,
    required DeleteItemUsecase deleteItemUsecase,
    required UploadPhotoUsecase uploadPhotoUsecase,
    required UploadVideoUsecase uploadVideoUsecase,
  })  : _getAllItemsUsecase = getAllItemsUsecase,
        _getItemByIdUsecase = getItemByIdUsecase,
        _getItemsByUserUsecase = getItemsByUserUsecase,
        _createItemUsecase = createItemUsecase,
        _updateItemUsecase = updateItemUsecase,
        _deleteItemUsecase = deleteItemUsecase,
        _uploadPhotoUsecase = uploadPhotoUsecase,
        _uploadVideoUsecase = uploadVideoUsecase,
        super(const ItemState()) {
    on<ItemGetAllEvent>(_onGetAll);
    on<ItemGetByIdEvent>(_onGetById);
    on<ItemGetMyItemsEvent>(_onGetMyItems);
    on<ItemCreateEvent>(_onCreate);
    on<ItemUpdateEvent>(_onUpdate);
    on<ItemDeleteEvent>(_onDelete);
    on<ItemUploadPhotoEvent>(_onUploadPhoto);
    on<ItemUploadVideoEvent>(_onUploadVideo);
    on<ItemClearErrorEvent>(_onClearError);
    on<ItemClearSelectedEvent>(_onClearSelected);
    on<ItemClearReportStateEvent>(_onClearReportState);
  }

  Future<void> _onGetAll(
    ItemGetAllEvent event,
    Emitter<ItemState> emit,
  ) async {
    emit(state.copyWith(status: ItemStatus.loading));

    final result = await _getAllItemsUsecase();

    result.fold(
      (failure) => emit(state.copyWith(
        status: ItemStatus.error,
        errorMessage: failure.message,
      )),
      (items) {
        final lostItems =
            items.where((item) => item.type == ItemType.lost).toList();
        final foundItems =
            items.where((item) => item.type == ItemType.found).toList();
        emit(state.copyWith(
          status: ItemStatus.loaded,
          items: items,
          lostItems: lostItems,
          foundItems: foundItems,
        ));
      },
    );
  }

  Future<void> _onGetById(
    ItemGetByIdEvent event,
    Emitter<ItemState> emit,
  ) async {
    emit(state.copyWith(status: ItemStatus.loading));

    final result =
        await _getItemByIdUsecase(GetItemByIdParams(itemId: event.itemId));

    result.fold(
      (failure) => emit(state.copyWith(
        status: ItemStatus.error,
        errorMessage: failure.message,
      )),
      (item) => emit(state.copyWith(
        status: ItemStatus.loaded,
        selectedItem: item,
      )),
    );
  }

  Future<void> _onGetMyItems(
    ItemGetMyItemsEvent event,
    Emitter<ItemState> emit,
  ) async {
    emit(state.copyWith(status: ItemStatus.loading));

    final result = await _getItemsByUserUsecase(
      GetItemsByUserParams(userId: event.userId),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: ItemStatus.error,
        errorMessage: failure.message,
      )),
      (items) {
        final myLostItems =
            items.where((item) => item.type == ItemType.lost).toList();
        final myFoundItems =
            items.where((item) => item.type == ItemType.found).toList();
        emit(state.copyWith(
          status: ItemStatus.loaded,
          myLostItems: myLostItems,
          myFoundItems: myFoundItems,
        ));
      },
    );
  }

  Future<void> _onCreate(
    ItemCreateEvent event,
    Emitter<ItemState> emit,
  ) async {
    emit(state.copyWith(status: ItemStatus.loading));

    final result = await _createItemUsecase(
      CreateItemParams(
        itemName: event.itemName,
        description: event.description,
        category: event.category,
        location: event.location,
        type: event.type,
        reportedBy: event.reportedBy,
        media: event.media,
        mediaType: event.mediaType,
      ),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: ItemStatus.error,
        errorMessage: failure.message,
      )),
      (success) {
        emit(state.copyWith(
          status: ItemStatus.created,
          resetUploadedPhotoUrl: true,
        ));
        add(const ItemGetAllEvent());
      },
    );
  }

  Future<void> _onUpdate(
    ItemUpdateEvent event,
    Emitter<ItemState> emit,
  ) async {
    emit(state.copyWith(status: ItemStatus.loading));

    final result = await _updateItemUsecase(
      UpdateItemParams(
        itemId: event.itemId,
        itemName: event.itemName,
        description: event.description,
        category: event.category,
        location: event.location,
        type: event.type,
        claimedBy: event.claimedBy,
        media: event.media,
        mediaType: event.mediaType,
        isClaimed: event.isClaimed,
        status: event.status,
      ),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: ItemStatus.error,
        errorMessage: failure.message,
      )),
      (success) {
        emit(state.copyWith(status: ItemStatus.updated));
        add(const ItemGetAllEvent());
      },
    );
  }

  Future<void> _onDelete(
    ItemDeleteEvent event,
    Emitter<ItemState> emit,
  ) async {
    emit(state.copyWith(status: ItemStatus.loading));

    final result =
        await _deleteItemUsecase(DeleteItemParams(itemId: event.itemId));

    result.fold(
      (failure) => emit(state.copyWith(
        status: ItemStatus.error,
        errorMessage: failure.message,
      )),
      (success) {
        emit(state.copyWith(status: ItemStatus.deleted));
        add(const ItemGetAllEvent());
      },
    );
  }

  Future<void> _onUploadPhoto(
    ItemUploadPhotoEvent event,
    Emitter<ItemState> emit,
  ) async {
    emit(state.copyWith(status: ItemStatus.loading));

    final result = await _uploadPhotoUsecase(event.photo);

    result.fold(
      (failure) => emit(state.copyWith(
        status: ItemStatus.error,
        errorMessage: failure.message,
      )),
      (url) => emit(state.copyWith(
        status: ItemStatus.loaded,
        uploadedPhotoUrl: url,
      )),
    );
  }

  Future<void> _onUploadVideo(
    ItemUploadVideoEvent event,
    Emitter<ItemState> emit,
  ) async {
    emit(state.copyWith(status: ItemStatus.loading));

    final result = await _uploadVideoUsecase(event.video);

    result.fold(
      (failure) => emit(state.copyWith(
        status: ItemStatus.error,
        errorMessage: failure.message,
      )),
      (url) => emit(state.copyWith(
        status: ItemStatus.loaded,
        uploadedPhotoUrl: url,
      )),
    );
  }

  void _onClearError(
    ItemClearErrorEvent event,
    Emitter<ItemState> emit,
  ) {
    emit(state.copyWith(resetErrorMessage: true));
  }

  void _onClearSelected(
    ItemClearSelectedEvent event,
    Emitter<ItemState> emit,
  ) {
    emit(state.copyWith(resetSelectedItem: true));
  }

  void _onClearReportState(
    ItemClearReportStateEvent event,
    Emitter<ItemState> emit,
  ) {
    emit(state.copyWith(
      status: ItemStatus.initial,
      resetUploadedPhotoUrl: true,
      resetErrorMessage: true,
    ));
  }
}
