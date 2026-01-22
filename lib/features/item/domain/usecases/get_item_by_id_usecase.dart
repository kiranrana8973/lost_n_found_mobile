import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/core/usecases/app_usecases.dart';
import 'package:lost_n_found/features/item/data/repositories/item_repository.dart';
import 'package:lost_n_found/features/item/domain/entities/item_entity.dart';
import 'package:lost_n_found/features/item/domain/repositories/item_repository.dart';

class GetItemByIdParams extends Equatable {
  final String itemId;

  const GetItemByIdParams({required this.itemId});

  @override
  List<Object?> get props => [itemId];
}

final getItemByIdUsecaseProvider = Provider<GetItemByIdUsecase>((ref) {
  final itemRepository = ref.read(itemRepositoryProvider);
  return GetItemByIdUsecase(itemRepository: itemRepository);
});

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
