import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/core/usecases/app_usecases.dart';
import 'package:lost_n_found/features/category/domain/entities/category_entity.dart';
import 'package:lost_n_found/features/category/domain/repositories/category_repository.dart';

class GetCategoryByIdParams extends Equatable {
  final String categoryId;

  const GetCategoryByIdParams({required this.categoryId});

  @override
  List<Object?> get props => [categoryId];
}

class GetCategoryByIdUsecase
    implements UsecaseWithParms<CategoryEntity, GetCategoryByIdParams> {
  final ICategoryRepository _categoryRepository;

  GetCategoryByIdUsecase({required ICategoryRepository categoryRepository})
      : _categoryRepository = categoryRepository;

  @override
  Future<Either<Failure, CategoryEntity>> call(GetCategoryByIdParams params) {
    return _categoryRepository.getCategoryById(params.categoryId);
  }
}
