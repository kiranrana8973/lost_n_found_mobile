import 'dart:io';
import 'package:mocktail/mocktail.dart';
import 'package:lost_n_found/features/auth/domain/repositories/auth_repository.dart';
import 'package:lost_n_found/features/item/domain/repositories/item_repository.dart';
import 'package:lost_n_found/features/batch/domain/repositories/batch_repository.dart';
import 'package:lost_n_found/features/category/domain/repositories/category_repository.dart';
import 'package:lost_n_found/features/auth/data/datasources/auth_datasource.dart';
import 'package:lost_n_found/features/item/data/datasources/item_datasource.dart';
import 'package:lost_n_found/features/batch/data/datasources/batch_datasource.dart';
import 'package:lost_n_found/features/category/data/datasources/category_datasource.dart';
import 'package:lost_n_found/core/services/connectivity/network_info.dart';
import 'package:lost_n_found/features/auth/domain/usecases/login_usecase.dart';
import 'package:lost_n_found/features/auth/domain/usecases/register_usecase.dart';
import 'package:lost_n_found/features/auth/domain/usecases/logout_usecase.dart';
import 'package:lost_n_found/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:lost_n_found/features/item/domain/usecases/get_all_items_usecase.dart';
import 'package:lost_n_found/features/item/domain/usecases/get_item_by_id_usecase.dart';
import 'package:lost_n_found/features/item/domain/usecases/get_items_by_user_usecase.dart';
import 'package:lost_n_found/features/item/domain/usecases/create_item_usecase.dart';
import 'package:lost_n_found/features/item/domain/usecases/update_item_usecase.dart';
import 'package:lost_n_found/features/item/domain/usecases/delete_item_usecase.dart';
import 'package:lost_n_found/features/item/domain/usecases/upload_photo_usecase.dart';
import 'package:lost_n_found/features/item/domain/usecases/upload_video_usecase.dart';
import 'package:lost_n_found/features/batch/domain/usecases/get_all_batch_usecase.dart';
import 'package:lost_n_found/features/batch/domain/usecases/get_batch_byid_usecase.dart';
import 'package:lost_n_found/features/batch/domain/usecases/create_batch_usecase.dart';
import 'package:lost_n_found/features/batch/domain/usecases/update_batch_usecase.dart';
import 'package:lost_n_found/features/batch/domain/usecases/delete_batch_usecase.dart';
import 'package:lost_n_found/features/category/domain/usecases/get_all_categories_usecase.dart';
import 'package:lost_n_found/features/category/domain/usecases/get_category_by_id_usecase.dart';
import 'package:lost_n_found/features/category/domain/usecases/create_category_usecase.dart';
import 'package:lost_n_found/features/category/domain/usecases/update_category_usecase.dart';
import 'package:lost_n_found/features/category/domain/usecases/delete_category_usecase.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

class MockItemRepository extends Mock implements IItemRepository {}

class MockBatchRepository extends Mock implements IBatchRepository {}

class MockCategoryRepository extends Mock implements ICategoryRepository {}

class MockAuthLocalDataSource extends Mock implements IAuthLocalDataSource {}

class MockAuthRemoteDataSource extends Mock implements IAuthRemoteDataSource {}

class MockItemLocalDataSource extends Mock implements IItemLocalDataSource {}

class MockItemRemoteDataSource extends Mock implements IItemRemoteDataSource {}

class MockBatchLocalDataSource extends Mock implements IBatchLocalDataSource {}

class MockBatchRemoteDataSource extends Mock
    implements IBatchRemoteDataSource {}

class MockCategoryLocalDataSource extends Mock implements ICategoryDataSource {}

class MockCategoryRemoteDataSource extends Mock
    implements ICategoryRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockLoginUsecase extends Mock implements LoginUsecase {}

class MockRegisterUsecase extends Mock implements RegisterUsecase {}

class MockLogoutUsecase extends Mock implements LogoutUsecase {}

class MockGetCurrentUserUsecase extends Mock implements GetCurrentUserUsecase {}

class MockGetAllItemsUsecase extends Mock implements GetAllItemsUsecase {}

class MockGetItemByIdUsecase extends Mock implements GetItemByIdUsecase {}

class MockGetItemsByUserUsecase extends Mock implements GetItemsByUserUsecase {}

class MockCreateItemUsecase extends Mock implements CreateItemUsecase {}

class MockUpdateItemUsecase extends Mock implements UpdateItemUsecase {}

class MockDeleteItemUsecase extends Mock implements DeleteItemUsecase {}

class MockUploadPhotoUsecase extends Mock implements UploadPhotoUsecase {}

class MockUploadVideoUsecase extends Mock implements UploadVideoUsecase {}

class MockGetAllBatchUsecase extends Mock implements GetAllBatchUsecase {}

class MockGetBatchByIdUsecase extends Mock implements GetBatchByIdUsecase {}

class MockCreateBatchUsecase extends Mock implements CreateBatchUsecase {}

class MockUpdateBatchUsecase extends Mock implements UpdateBatchUsecase {}

class MockDeleteBatchUsecase extends Mock implements DeleteBatchUsecase {}

class MockGetAllCategoriesUsecase extends Mock
    implements GetAllCategoriesUsecase {}

class MockGetCategoryByIdUsecase extends Mock
    implements GetCategoryByIdUsecase {}

class MockCreateCategoryUsecase extends Mock implements CreateCategoryUsecase {}

class MockUpdateCategoryUsecase extends Mock implements UpdateCategoryUsecase {}

class MockDeleteCategoryUsecase extends Mock implements DeleteCategoryUsecase {}

class FakeFile extends Fake implements File {}
