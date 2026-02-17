import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/core/usecases/app_usecases.dart';
import 'package:lost_n_found/features/item/domain/repositories/item_repository.dart';

class UploadPhotoUsecase implements UsecaseWithParms<String, File> {
  final IItemRepository _itemRepository;

  UploadPhotoUsecase({required IItemRepository itemRepository})
      : _itemRepository = itemRepository;

  @override
  Future<Either<Failure, String>> call(File photo) {
    return _itemRepository.uploadPhoto(photo);
  }
}


