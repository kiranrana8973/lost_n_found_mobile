import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/core/usecases/app_usecases.dart';
import 'package:lost_n_found/features/item/domain/repositories/item_repository.dart';

class UploadVideoUsecase implements UsecaseWithParms<String, File> {
  final IItemRepository _itemRepository;

  UploadVideoUsecase({required IItemRepository itemRepository})
      : _itemRepository = itemRepository;

  @override
  Future<Either<Failure, String>> call(File video) {
    return _itemRepository.uploadVideo(video);
  }
}


