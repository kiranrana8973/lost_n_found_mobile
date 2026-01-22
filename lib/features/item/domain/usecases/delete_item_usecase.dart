import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/core/usecases/app_usecases.dart';
import 'package:lost_n_found/features/item/data/repositories/item_repository.dart';
import 'package:lost_n_found/features/item/domain/repositories/item_repository.dart';

class DeleteItemParams extends Equatable {
  final String itemId;

  const DeleteItemParams({required this.itemId});

  @override
  List<Object?> get props => [itemId];
}

final deleteItemUsecaseProvider = Provider<DeleteItemUsecase>((ref) {
  final itemRepository = ref.read(itemRepositoryProvider);
  return DeleteItemUsecase(itemRepository: itemRepository);
});

class DeleteItemUsecase implements UsecaseWithParms<bool, DeleteItemParams> {
  final IItemRepository _itemRepository;

  DeleteItemUsecase({required IItemRepository itemRepository})
    : _itemRepository = itemRepository;

  @override
  Future<Either<Failure, bool>> call(DeleteItemParams params) {
    return _itemRepository.deleteItem(params.itemId);
  }
}
