import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/core/usecases/app_usecases.dart';
import 'package:lost_n_found/features/item/data/repositories/item_repository.dart';
import 'package:lost_n_found/features/item/domain/repositories/item_repository.dart';

final uploadVideoUsecaseProvider = Provider<UploadVideoUsecase>((ref) {
  final itemRepository = ref.read(itemRepositoryProvider);
  return UploadVideoUsecase(itemRepository: itemRepository);
});

class UploadVideoUsecase implements UsecaseWithParams<String, File> {
  final IItemRepository _itemRepository;

  UploadVideoUsecase({required IItemRepository itemRepository})
    : _itemRepository = itemRepository;

  @override
  Future<Either<Failure, String>> call(File video) {
    return _itemRepository.uploadVideo(video);
  }
}
