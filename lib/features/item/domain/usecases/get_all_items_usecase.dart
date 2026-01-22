import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/core/usecases/app_usecases.dart';
import 'package:lost_n_found/features/item/data/repositories/item_repository.dart';
import 'package:lost_n_found/features/item/domain/entities/item_entity.dart';
import 'package:lost_n_found/features/item/domain/repositories/item_repository.dart';

final getAllItemsUsecaseProvider = Provider<GetAllItemsUsecase>((ref) {
  final itemRepository = ref.read(itemRepositoryProvider);
  return GetAllItemsUsecase(itemRepository: itemRepository);
});

class GetAllItemsUsecase implements UsecaseWithoutParms<List<ItemEntity>> {
  final IItemRepository _itemRepository;

  GetAllItemsUsecase({required IItemRepository itemRepository})
    : _itemRepository = itemRepository;

  @override
  Future<Either<Failure, List<ItemEntity>>> call() {
    return _itemRepository.getAllItems();
  }
}
