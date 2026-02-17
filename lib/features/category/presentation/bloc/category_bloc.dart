import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/create_category_usecase.dart';
import '../../domain/usecases/delete_category_usecase.dart';
import '../../domain/usecases/get_all_categories_usecase.dart';
import '../../domain/usecases/get_category_by_id_usecase.dart';
import '../../domain/usecases/update_category_usecase.dart';
import '../state/category_state.dart';
import 'category_event.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetAllCategoriesUsecase _getAllCategoriesUsecase;
  final GetCategoryByIdUsecase _getCategoryByIdUsecase;
  final CreateCategoryUsecase _createCategoryUsecase;
  final UpdateCategoryUsecase _updateCategoryUsecase;
  final DeleteCategoryUsecase _deleteCategoryUsecase;

  CategoryBloc({
    required GetAllCategoriesUsecase getAllCategoriesUsecase,
    required GetCategoryByIdUsecase getCategoryByIdUsecase,
    required CreateCategoryUsecase createCategoryUsecase,
    required UpdateCategoryUsecase updateCategoryUsecase,
    required DeleteCategoryUsecase deleteCategoryUsecase,
  }) : _getAllCategoriesUsecase = getAllCategoriesUsecase,
       _getCategoryByIdUsecase = getCategoryByIdUsecase,
       _createCategoryUsecase = createCategoryUsecase,
       _updateCategoryUsecase = updateCategoryUsecase,
       _deleteCategoryUsecase = deleteCategoryUsecase,
       super(const CategoryState()) {
    on<CategoryGetAllEvent>(_onGetAll);
    on<CategoryGetByIdEvent>(_onGetById);
    on<CategoryCreateEvent>(_onCreate);
    on<CategoryUpdateEvent>(_onUpdate);
    on<CategoryDeleteEvent>(_onDelete);
    on<CategoryClearErrorEvent>(_onClearError);
    on<CategoryClearSelectedEvent>(_onClearSelected);
  }

  Future<void> _onGetAll(
    CategoryGetAllEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(state.copyWith(status: CategoryStatus.loading));

    final result = await _getAllCategoriesUsecase();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CategoryStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (categories) => emit(
        state.copyWith(status: CategoryStatus.loaded, categories: categories),
      ),
    );
  }

  Future<void> _onGetById(
    CategoryGetByIdEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(state.copyWith(status: CategoryStatus.loading));

    final result = await _getCategoryByIdUsecase(
      GetCategoryByIdParams(categoryId: event.categoryId),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CategoryStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (category) => emit(
        state.copyWith(
          status: CategoryStatus.loaded,
          selectedCategory: category,
        ),
      ),
    );
  }

  Future<void> _onCreate(
    CategoryCreateEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(state.copyWith(status: CategoryStatus.loading));

    final result = await _createCategoryUsecase(
      CreateCategoryParams(name: event.name, description: event.description),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CategoryStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (success) {
        emit(state.copyWith(status: CategoryStatus.created));
        add(const CategoryGetAllEvent());
      },
    );
  }

  Future<void> _onUpdate(
    CategoryUpdateEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(state.copyWith(status: CategoryStatus.loading));

    final result = await _updateCategoryUsecase(
      UpdateCategoryParams(
        categoryId: event.categoryId,
        name: event.name,
        description: event.description,
        status: event.status,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CategoryStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (success) {
        emit(state.copyWith(status: CategoryStatus.updated));
        add(const CategoryGetAllEvent());
      },
    );
  }

  Future<void> _onDelete(
    CategoryDeleteEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(state.copyWith(status: CategoryStatus.loading));

    final result = await _deleteCategoryUsecase(
      DeleteCategoryParams(categoryId: event.categoryId),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CategoryStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (success) {
        emit(state.copyWith(status: CategoryStatus.deleted));
        add(const CategoryGetAllEvent());
      },
    );
  }

  void _onClearError(
    CategoryClearErrorEvent event,
    Emitter<CategoryState> emit,
  ) {
    emit(state.copyWith(clearErrorMessage: true));
  }

  void _onClearSelected(
    CategoryClearSelectedEvent event,
    Emitter<CategoryState> emit,
  ) {
    emit(state.copyWith(clearSelectedCategory: true));
  }
}
