import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/core/usecases/app_usecases.dart';
import 'package:lost_n_found/features/item/data/repositories/item_repository.dart';
import 'package:lost_n_found/features/item/domain/entities/item_entity.dart';
import 'package:lost_n_found/features/item/domain/repositories/item_repository.dart';

class UpdateItemParams extends Equatable {
  final String itemId;
  final String itemName;
  final String? description;
  final String? categoryId;
  final String location;
  final ItemType type;
  final String? claimedBy;
  final String? media;
  final String? mediaType;
  final bool? isClaimed;
  final String? status;

  const UpdateItemParams({
    required this.itemId,
    required this.itemName,
    this.description,
    this.categoryId,
    required this.location,
    required this.type,
    this.claimedBy,
    this.media,
    this.mediaType,
    this.isClaimed,
    this.status,
  });

  @override
  List<Object?> get props => [
        itemId,
        itemName,
        description,
        categoryId,
        location,
        type,
        claimedBy,
        media,
        mediaType,
        isClaimed,
        status,
      ];
}

final updateItemUsecaseProvider = Provider<UpdateItemUsecase>((ref) {
  final itemRepository = ref.read(itemRepositoryProvider);
  return UpdateItemUsecase(itemRepository: itemRepository);
});

class UpdateItemUsecase implements UsecaseWithParms<bool, UpdateItemParams> {
  final IItemRepository _itemRepository;

  UpdateItemUsecase({required IItemRepository itemRepository})
      : _itemRepository = itemRepository;

  @override
  Future<Either<Failure, bool>> call(UpdateItemParams params) {
    final itemEntity = ItemEntity(
      itemId: params.itemId,
      itemName: params.itemName,
      description: params.description,
      categoryId: params.categoryId,
      location: params.location,
      type: params.type,
      claimedBy: params.claimedBy,
      media: params.media,
      mediaType: params.mediaType,
      isClaimed: params.isClaimed ?? false,
      status: params.status,
    );

    return _itemRepository.updateItem(itemEntity);
  }
}
