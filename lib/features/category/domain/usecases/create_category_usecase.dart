import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/core/usecases/app_usecases.dart';
import 'package:lost_n_found/features/category/data/repositories/category_repository.dart';
import 'package:lost_n_found/features/category/domain/entities/category_entity.dart';
import 'package:lost_n_found/features/category/domain/repositories/category_repository.dart';

class CreateCategoryParams extends Equatable {
  final String name;
  final String? description;

  const CreateCategoryParams({
    required this.name,
    this.description,
  });

  @override
  List<Object?> get props => [name, description];
}

final createCategoryUsecaseProvider = Provider<CreateCategoryUsecase>((ref) {
  final categoryRepository = ref.read(categoryRepositoryProvider);
  return CreateCategoryUsecase(categoryRepository: categoryRepository);
});

class CreateCategoryUsecase
    implements UsecaseWithParms<bool, CreateCategoryParams> {
  final ICategoryRepository _categoryRepository;

  CreateCategoryUsecase({required ICategoryRepository categoryRepository})
      : _categoryRepository = categoryRepository;

  @override
  Future<Either<Failure, bool>> call(CreateCategoryParams params) {
    final categoryEntity = CategoryEntity(
      name: params.name,
      description: params.description,
    );

    return _categoryRepository.createCategory(categoryEntity);
  }
}
