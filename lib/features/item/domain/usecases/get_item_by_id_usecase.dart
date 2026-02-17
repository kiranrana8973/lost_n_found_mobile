import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/core/usecases/app_usecases.dart';
import 'package:lost_n_found/features/item/domain/entities/item_entity.dart';
import 'package:lost_n_found/features/item/domain/repositories/item_repository.dart';

class GetItemByIdParams extends Equatable {
  final String itemId;

  const GetItemByIdParams({required this.itemId});

  @override
  List<Object?> get props => [itemId];
}

class GetItemByIdUsecase
    implements UsecaseWithParms<ItemEntity, GetItemByIdParams> {
  final IItemRepository _itemRepository;

  GetItemByIdUsecase({required IItemRepository itemRepository})
    : _itemRepository = itemRepository;

  @override
  Future<Either<Failure, ItemEntity>> call(GetItemByIdParams params) {
    return _itemRepository.getItemById(params.itemId);
  }
}
