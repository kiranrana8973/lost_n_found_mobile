import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/datasources/local/auth_local_datasource.dart';
import '../../features/auth/data/datasources/remote/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

import '../../features/batch/data/datasources/local/batch_local_datasource.dart';
import '../../features/batch/data/datasources/remote/batch_remote_datasource.dart';
import '../../features/batch/data/repositories/batch_repository.dart';
import '../../features/batch/domain/repositories/batch_repository.dart';
import '../../features/batch/domain/usecases/create_batch_usecase.dart';
import '../../features/batch/domain/usecases/delete_batch_usecase.dart';
import '../../features/batch/domain/usecases/get_all_batch_usecase.dart';
import '../../features/batch/domain/usecases/get_batch_byid_usecase.dart';
import '../../features/batch/domain/usecases/update_batch_usecase.dart';
import '../../features/batch/presentation/bloc/batch_bloc.dart';

import '../../features/category/data/datasources/local/category_local_datasource.dart';
import '../../features/category/data/datasources/remote/category_remote_datasource.dart';
import '../../features/category/data/repositories/category_repository.dart';
import '../../features/category/domain/repositories/category_repository.dart';
import '../../features/category/domain/usecases/create_category_usecase.dart';
import '../../features/category/domain/usecases/delete_category_usecase.dart';
import '../../features/category/domain/usecases/get_all_categories_usecase.dart';
import '../../features/category/domain/usecases/get_category_by_id_usecase.dart';
import '../../features/category/domain/usecases/update_category_usecase.dart';
import '../../features/category/presentation/bloc/category_bloc.dart';

import '../../features/item/data/datasources/local/item_local_datasource.dart';
import '../../features/item/data/datasources/remote/item_remote_datasource.dart';
import '../../features/item/data/repositories/item_repository.dart';
import '../../features/item/domain/repositories/item_repository.dart';
import '../../features/item/domain/usecases/create_item_usecase.dart';
import '../../features/item/domain/usecases/delete_item_usecase.dart';
import '../../features/item/domain/usecases/get_all_items_usecase.dart';
import '../../features/item/domain/usecases/get_item_by_id_usecase.dart';
import '../../features/item/domain/usecases/get_items_by_user_usecase.dart';
import '../../features/item/domain/usecases/update_item_usecase.dart';
import '../../features/item/domain/usecases/upload_photo_usecase.dart';
import '../../features/item/domain/usecases/upload_video_usecase.dart';
import '../../features/item/presentation/bloc/item_bloc.dart';

import '../api/api_client.dart';
import '../services/connectivity/network_info.dart';
import '../services/hive/hive_service.dart';
import '../services/storage/token_service.dart';
import '../services/storage/user_session_service.dart';

final serviceLocator = GetIt.instance;

Future<void> initializeDependencies(SharedPreferences prefs) async {
  // ======================== External ========================
  serviceLocator.registerSingleton<SharedPreferences>(prefs);

  // ======================== Core Services ========================
  serviceLocator.registerLazySingleton<HiveService>(() => HiveService());
  serviceLocator.registerLazySingleton<ApiClient>(() => ApiClient());
  serviceLocator.registerLazySingleton<NetworkInfo>(
    () => NetworkInfo(Connectivity()),
  );
  serviceLocator.registerLazySingleton<TokenService>(
    () => TokenService(prefs: serviceLocator<SharedPreferences>()),
  );
  serviceLocator.registerLazySingleton<UserSessionService>(
    () => UserSessionService(prefs: serviceLocator<SharedPreferences>()),
  );

  // ======================== Auth Feature ========================
  // Datasources
  serviceLocator.registerLazySingleton<AuthLocalDatasource>(
    () => AuthLocalDatasource(
      hiveService: serviceLocator<HiveService>(),
      userSessionService: serviceLocator<UserSessionService>(),
    ),
  );
  serviceLocator.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasource(
      apiClient: serviceLocator<ApiClient>(),
      userSessionService: serviceLocator<UserSessionService>(),
      tokenService: serviceLocator<TokenService>(),
    ),
  );
  // Repository
  serviceLocator.registerLazySingleton<IAuthRepository>(
    () => AuthRepository(
      authDatasource: serviceLocator<AuthLocalDatasource>(),
      authRemoteDataSource: serviceLocator<AuthRemoteDatasource>(),
      networkInfo: serviceLocator<NetworkInfo>(),
    ),
  );
  // Usecases
  serviceLocator.registerLazySingleton<LoginUsecase>(
    () => LoginUsecase(authRepository: serviceLocator<IAuthRepository>()),
  );
  serviceLocator.registerLazySingleton<RegisterUsecase>(
    () => RegisterUsecase(authRepository: serviceLocator<IAuthRepository>()),
  );
  serviceLocator.registerLazySingleton<LogoutUsecase>(
    () => LogoutUsecase(authRepository: serviceLocator<IAuthRepository>()),
  );
  serviceLocator.registerLazySingleton<GetCurrentUserUsecase>(
    () => GetCurrentUserUsecase(
      authRepository: serviceLocator<IAuthRepository>(),
    ),
  );
  // BLoC
  serviceLocator.registerFactory<AuthBloc>(
    () => AuthBloc(
      registerUsecase: serviceLocator<RegisterUsecase>(),
      loginUsecase: serviceLocator<LoginUsecase>(),
      getCurrentUserUsecase: serviceLocator<GetCurrentUserUsecase>(),
      logoutUsecase: serviceLocator<LogoutUsecase>(),
    ),
  );

  // ======================== Item Feature ========================
  // Datasources
  serviceLocator.registerLazySingleton<ItemLocalDatasource>(
    () => ItemLocalDatasource(hiveService: serviceLocator<HiveService>()),
  );
  serviceLocator.registerLazySingleton<ItemRemoteDatasource>(
    () => ItemRemoteDatasource(
      apiClient: serviceLocator<ApiClient>(),
      tokenService: serviceLocator<TokenService>(),
    ),
  );
  // Repository
  serviceLocator.registerLazySingleton<IItemRepository>(
    () => ItemRepository(
      localDatasource: serviceLocator<ItemLocalDatasource>(),
      remoteDatasource: serviceLocator<ItemRemoteDatasource>(),
      networkInfo: serviceLocator<NetworkInfo>(),
    ),
  );
  // Usecases
  serviceLocator.registerLazySingleton<GetAllItemsUsecase>(
    () => GetAllItemsUsecase(itemRepository: serviceLocator<IItemRepository>()),
  );
  serviceLocator.registerLazySingleton<GetItemByIdUsecase>(
    () => GetItemByIdUsecase(itemRepository: serviceLocator<IItemRepository>()),
  );
  serviceLocator.registerLazySingleton<GetItemsByUserUsecase>(
    () => GetItemsByUserUsecase(
      itemRepository: serviceLocator<IItemRepository>(),
    ),
  );
  serviceLocator.registerLazySingleton<CreateItemUsecase>(
    () => CreateItemUsecase(itemRepository: serviceLocator<IItemRepository>()),
  );
  serviceLocator.registerLazySingleton<UpdateItemUsecase>(
    () => UpdateItemUsecase(itemRepository: serviceLocator<IItemRepository>()),
  );
  serviceLocator.registerLazySingleton<DeleteItemUsecase>(
    () => DeleteItemUsecase(itemRepository: serviceLocator<IItemRepository>()),
  );
  serviceLocator.registerLazySingleton<UploadPhotoUsecase>(
    () => UploadPhotoUsecase(itemRepository: serviceLocator<IItemRepository>()),
  );
  serviceLocator.registerLazySingleton<UploadVideoUsecase>(
    () => UploadVideoUsecase(itemRepository: serviceLocator<IItemRepository>()),
  );
  // BLoC
  serviceLocator.registerFactory<ItemBloc>(
    () => ItemBloc(
      getAllItemsUsecase: serviceLocator<GetAllItemsUsecase>(),
      getItemByIdUsecase: serviceLocator<GetItemByIdUsecase>(),
      getItemsByUserUsecase: serviceLocator<GetItemsByUserUsecase>(),
      createItemUsecase: serviceLocator<CreateItemUsecase>(),
      updateItemUsecase: serviceLocator<UpdateItemUsecase>(),
      deleteItemUsecase: serviceLocator<DeleteItemUsecase>(),
      uploadPhotoUsecase: serviceLocator<UploadPhotoUsecase>(),
      uploadVideoUsecase: serviceLocator<UploadVideoUsecase>(),
    ),
  );

  // ======================== Category Feature ========================
  // Datasources
  serviceLocator.registerLazySingleton<CategoryLocalDatasource>(
    () => CategoryLocalDatasource(hiveService: serviceLocator<HiveService>()),
  );
  serviceLocator.registerLazySingleton<CategoryRemoteDatasource>(
    () => CategoryRemoteDatasource(apiClient: serviceLocator<ApiClient>()),
  );
  // Repository
  serviceLocator.registerLazySingleton<ICategoryRepository>(
    () => CategoryRepository(
      categoryLocalDatasource: serviceLocator<CategoryLocalDatasource>(),
      categoryRemoteDatasource: serviceLocator<CategoryRemoteDatasource>(),
      networkInfo: serviceLocator<NetworkInfo>(),
    ),
  );
  // Usecases
  serviceLocator.registerLazySingleton<GetAllCategoriesUsecase>(
    () => GetAllCategoriesUsecase(
      categoryRepository: serviceLocator<ICategoryRepository>(),
    ),
  );
  serviceLocator.registerLazySingleton<GetCategoryByIdUsecase>(
    () => GetCategoryByIdUsecase(
      categoryRepository: serviceLocator<ICategoryRepository>(),
    ),
  );
  serviceLocator.registerLazySingleton<CreateCategoryUsecase>(
    () => CreateCategoryUsecase(
      categoryRepository: serviceLocator<ICategoryRepository>(),
    ),
  );
  serviceLocator.registerLazySingleton<UpdateCategoryUsecase>(
    () => UpdateCategoryUsecase(
      categoryRepository: serviceLocator<ICategoryRepository>(),
    ),
  );
  serviceLocator.registerLazySingleton<DeleteCategoryUsecase>(
    () => DeleteCategoryUsecase(
      categoryRepository: serviceLocator<ICategoryRepository>(),
    ),
  );
  // BLoC
  serviceLocator.registerFactory<CategoryBloc>(
    () => CategoryBloc(
      getAllCategoriesUsecase: serviceLocator<GetAllCategoriesUsecase>(),
      getCategoryByIdUsecase: serviceLocator<GetCategoryByIdUsecase>(),
      createCategoryUsecase: serviceLocator<CreateCategoryUsecase>(),
      updateCategoryUsecase: serviceLocator<UpdateCategoryUsecase>(),
      deleteCategoryUsecase: serviceLocator<DeleteCategoryUsecase>(),
    ),
  );

  // ======================== Batch Feature ========================
  // Datasources
  serviceLocator.registerLazySingleton<BatchLocalDatasource>(
    () => BatchLocalDatasource(hiveService: serviceLocator<HiveService>()),
  );
  serviceLocator.registerLazySingleton<BatchRemoteDatasource>(
    () => BatchRemoteDatasource(apiClient: serviceLocator<ApiClient>()),
  );
  // Repository
  serviceLocator.registerLazySingleton<IBatchRepository>(
    () => BatchRepository(
      batchDatasource: serviceLocator<BatchLocalDatasource>(),
      batchRemoteDataSource: serviceLocator<BatchRemoteDatasource>(),
      networkInfo: serviceLocator<NetworkInfo>(),
    ),
  );
  // Usecases
  serviceLocator.registerLazySingleton<GetAllBatchUsecase>(
    () => GetAllBatchUsecase(
      batchRepository: serviceLocator<IBatchRepository>(),
    ),
  );
  serviceLocator.registerLazySingleton<GetBatchByIdUsecase>(
    () => GetBatchByIdUsecase(
      batchRepository: serviceLocator<IBatchRepository>(),
    ),
  );
  serviceLocator.registerLazySingleton<CreateBatchUsecase>(
    () => CreateBatchUsecase(
      batchRepository: serviceLocator<IBatchRepository>(),
    ),
  );
  serviceLocator.registerLazySingleton<UpdateBatchUsecase>(
    () => UpdateBatchUsecase(
      batchRepository: serviceLocator<IBatchRepository>(),
    ),
  );
  serviceLocator.registerLazySingleton<DeleteBatchUsecase>(
    () => DeleteBatchUsecase(
      batchRepository: serviceLocator<IBatchRepository>(),
    ),
  );
  // BLoC
  serviceLocator.registerFactory<BatchBloc>(
    () => BatchBloc(
      getAllBatchUsecase: serviceLocator<GetAllBatchUsecase>(),
      getBatchByIdUsecase: serviceLocator<GetBatchByIdUsecase>(),
      createBatchUsecase: serviceLocator<CreateBatchUsecase>(),
      updateBatchUsecase: serviceLocator<UpdateBatchUsecase>(),
      deleteBatchUsecase: serviceLocator<DeleteBatchUsecase>(),
    ),
  );
}
