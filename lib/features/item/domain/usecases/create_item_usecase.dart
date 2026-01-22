import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/core/usecases/app_usecases.dart';
import 'package:lost_n_found/features/item/data/repositories/item_repository.dart';
import 'package:lost_n_found/features/item/domain/entities/item_entity.dart';
import 'package:lost_n_found/features/item/domain/repositories/item_repository.dart';

class CreateItemParams extends Equatable {
  final String itemName;
  final String? description;
  final String? categoryId;
  final String location;
  final ItemType type;
  final String? reportedBy;
  final String? media;
  final String? mediaType;

  const CreateItemParams({
    required this.itemName,
    this.description,
    this.categoryId,
    required this.location,
    required this.type,
    this.reportedBy,
    this.media,
    this.mediaType,
  });

  @override
  List<Object?> get props => [
        itemName,
        description,
        categoryId,
        location,
        type,
        reportedBy,
        media,
        mediaType,
      ];
}

final createItemUsecaseProvider = Provider<CreateItemUsecase>((ref) {
  final itemRepository = ref.read(itemRepositoryProvider);
  return CreateItemUsecase(itemRepository: itemRepository);
});

class CreateItemUsecase implements UsecaseWithParms<bool, CreateItemParams> {
  final IItemRepository _itemRepository;

  CreateItemUsecase({required IItemRepository itemRepository})
      : _itemRepository = itemRepository;

  @override
  Future<Either<Failure, bool>> call(CreateItemParams params) {
    final itemEntity = ItemEntity(
      itemName: params.itemName,
      description: params.description,
      categoryId: params.categoryId,
      location: params.location,
      type: params.type,
      reportedBy: params.reportedBy,
      media: params.media,
      mediaType: params.mediaType,
    );

    return _itemRepository.createItem(itemEntity);
  }
}
