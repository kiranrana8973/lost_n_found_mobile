import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/core/usecases/app_usecases.dart';
import 'package:lost_n_found/features/category/domain/repositories/category_repository.dart';

class DeleteCategoryParams extends Equatable {
  final String categoryId;

  const DeleteCategoryParams({required this.categoryId});

  @override
  List<Object?> get props => [categoryId];
}

class DeleteCategoryUsecase
    implements UsecaseWithParms<bool, DeleteCategoryParams> {
  final ICategoryRepository _categoryRepository;

  DeleteCategoryUsecase({required ICategoryRepository categoryRepository})
      : _categoryRepository = categoryRepository;

  @override
  Future<Either<Failure, bool>> call(DeleteCategoryParams params) {
    return _categoryRepository.deleteCategory(params.categoryId);
  }
}
