import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/core/services/storage/user_session_service.dart';
import 'package:lost_n_found/features/category/domain/usecases/create_category_usecase.dart';
import 'package:lost_n_found/features/category/domain/usecases/delete_category_usecase.dart';
import 'package:lost_n_found/features/category/domain/usecases/get_all_categories_usecase.dart';
import 'package:lost_n_found/features/category/domain/usecases/get_category_by_id_usecase.dart';
import 'package:lost_n_found/features/category/domain/usecases/update_category_usecase.dart';
import 'package:lost_n_found/features/item/domain/usecases/create_item_usecase.dart';
import 'package:lost_n_found/features/item/domain/usecases/delete_item_usecase.dart';
import 'package:lost_n_found/features/item/domain/usecases/get_all_items_usecase.dart';
import 'package:lost_n_found/features/item/domain/usecases/get_item_by_id_usecase.dart';
import 'package:lost_n_found/features/item/domain/usecases/get_items_by_user_usecase.dart';
import 'package:lost_n_found/features/item/domain/usecases/update_item_usecase.dart';
import 'package:lost_n_found/features/item/domain/usecases/upload_photo_usecase.dart';
import 'package:lost_n_found/features/item/domain/usecases/upload_video_usecase.dart';
import 'package:lost_n_found/features/item/presentation/pages/my_items_page.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Mock classes
class MockUserSessionService extends Mock implements UserSessionService {}

class MockGetAllItemsUsecase extends Mock implements GetAllItemsUsecase {}

class MockGetItemByIdUsecase extends Mock implements GetItemByIdUsecase {}

class MockGetItemsByUserUsecase extends Mock implements GetItemsByUserUsecase {}

class MockCreateItemUsecase extends Mock implements CreateItemUsecase {}

class MockUpdateItemUsecase extends Mock implements UpdateItemUsecase {}

class MockDeleteItemUsecase extends Mock implements DeleteItemUsecase {}

class MockUploadPhotoUsecase extends Mock implements UploadPhotoUsecase {}

class MockUploadVideoUsecase extends Mock implements UploadVideoUsecase {}

class MockGetAllCategoriesUsecase extends Mock
    implements GetAllCategoriesUsecase {}

class MockGetCategoryByIdUsecase extends Mock
    implements GetCategoryByIdUsecase {}

class MockCreateCategoryUsecase extends Mock implements CreateCategoryUsecase {}

class MockUpdateCategoryUsecase extends Mock implements UpdateCategoryUsecase {}

class MockDeleteCategoryUsecase extends Mock implements DeleteCategoryUsecase {}

void main() {
  late SharedPreferences sharedPreferences;
  late MockUserSessionService mockUserSessionService;
  late MockGetAllItemsUsecase mockGetAllItemsUsecase;
  late MockGetItemByIdUsecase mockGetItemByIdUsecase;
  late MockGetItemsByUserUsecase mockGetItemsByUserUsecase;
  late MockCreateItemUsecase mockCreateItemUsecase;
  late MockUpdateItemUsecase mockUpdateItemUsecase;
  late MockDeleteItemUsecase mockDeleteItemUsecase;
  late MockUploadPhotoUsecase mockUploadPhotoUsecase;
  late MockUploadVideoUsecase mockUploadVideoUsecase;
  late MockGetAllCategoriesUsecase mockGetAllCategoriesUsecase;
  late MockGetCategoryByIdUsecase mockGetCategoryByIdUsecase;
  late MockCreateCategoryUsecase mockCreateCategoryUsecase;
  late MockUpdateCategoryUsecase mockUpdateCategoryUsecase;
  late MockDeleteCategoryUsecase mockDeleteCategoryUsecase;

  setUpAll(() async {
    registerFallbackValue(const GetItemsByUserParams(userId: ''));
    SharedPreferences.setMockInitialValues({});
    sharedPreferences = await SharedPreferences.getInstance();
  });

  setUp(() {
    mockUserSessionService = MockUserSessionService();
    mockGetAllItemsUsecase = MockGetAllItemsUsecase();
    mockGetItemByIdUsecase = MockGetItemByIdUsecase();
    mockGetItemsByUserUsecase = MockGetItemsByUserUsecase();
    mockCreateItemUsecase = MockCreateItemUsecase();
    mockUpdateItemUsecase = MockUpdateItemUsecase();
    mockDeleteItemUsecase = MockDeleteItemUsecase();
    mockUploadPhotoUsecase = MockUploadPhotoUsecase();
    mockUploadVideoUsecase = MockUploadVideoUsecase();
    mockGetAllCategoriesUsecase = MockGetAllCategoriesUsecase();
    mockGetCategoryByIdUsecase = MockGetCategoryByIdUsecase();
    mockCreateCategoryUsecase = MockCreateCategoryUsecase();
    mockUpdateCategoryUsecase = MockUpdateCategoryUsecase();
    mockDeleteCategoryUsecase = MockDeleteCategoryUsecase();

    // Setup default mocks
    when(() => mockUserSessionService.getCurrentUserId()).thenReturn('1');
    when(
      () => mockGetItemsByUserUsecase(any()),
    ).thenAnswer((_) async => const Right([]));
    when(
      () => mockGetAllCategoriesUsecase(),
    ).thenAnswer((_) async => const Right([]));
    when(
      () => mockGetAllItemsUsecase(),
    ).thenAnswer((_) async => const Right([]));
  });

  Widget createTestWidget() {
    return ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        userSessionServiceProvider.overrideWithValue(mockUserSessionService),
        getAllItemsUsecaseProvider.overrideWithValue(mockGetAllItemsUsecase),
        getItemByIdUsecaseProvider.overrideWithValue(mockGetItemByIdUsecase),
        getItemsByUserUsecaseProvider.overrideWithValue(
          mockGetItemsByUserUsecase,
        ),
        createItemUsecaseProvider.overrideWithValue(mockCreateItemUsecase),
        updateItemUsecaseProvider.overrideWithValue(mockUpdateItemUsecase),
        deleteItemUsecaseProvider.overrideWithValue(mockDeleteItemUsecase),
        uploadPhotoUsecaseProvider.overrideWithValue(mockUploadPhotoUsecase),
        uploadVideoUsecaseProvider.overrideWithValue(mockUploadVideoUsecase),
        getAllCategoriesUsecaseProvider.overrideWithValue(
          mockGetAllCategoriesUsecase,
        ),
        getCategoryByIdUsecaseProvider.overrideWithValue(
          mockGetCategoryByIdUsecase,
        ),
        createCategoryUsecaseProvider.overrideWithValue(
          mockCreateCategoryUsecase,
        ),
        updateCategoryUsecaseProvider.overrideWithValue(
          mockUpdateCategoryUsecase,
        ),
        deleteCategoryUsecaseProvider.overrideWithValue(
          mockDeleteCategoryUsecase,
        ),
      ],
      child: const MaterialApp(home: MyItemsPage()),
    );
  }

  group('MyItemsPage - UI Elements', () {
    testWidgets('should display scaffold', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should display My Items header', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('My Items'), findsOneWidget);
    });

    testWidgets('should display subtitle', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Track your reports'), findsOneWidget);
    });

    testWidgets('should display sort icon', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.sort_rounded), findsOneWidget);
    });

    testWidgets('should display Lost tab', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Lost'), findsOneWidget);
    });

    testWidgets('should display Found tab', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Found'), findsOneWidget);
    });
  });

  group('MyItemsPage - Tab Navigation', () {
    testWidgets('should display TabBar', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(TabBar), findsOneWidget);
    });

    testWidgets('should display TabBarView', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(TabBarView), findsOneWidget);
    });

    testWidgets('should switch to Found tab on tap', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Found'));
      await tester.pumpAndSettle();

      // Tab should be visible
      expect(find.text('Found'), findsOneWidget);
    });

    testWidgets('should switch to Lost tab on tap', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // First go to Found
      await tester.tap(find.text('Found'));
      await tester.pumpAndSettle();

      // Then back to Lost
      await tester.tap(find.text('Lost'));
      await tester.pumpAndSettle();

      expect(find.text('Lost'), findsOneWidget);
    });
  });

  group('MyItemsPage - Empty State', () {
    testWidgets('should show empty state for Lost items', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('No lost items reported'), findsOneWidget);
    });

    testWidgets('should show empty state for Found items', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Found'));
      await tester.pumpAndSettle();

      expect(find.text('No found items reported'), findsOneWidget);
    });

    testWidgets('should display search_off icon for empty lost items', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.search_off_rounded), findsWidgets);
    });

    testWidgets('should display check_circle icon for empty found items', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Found'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check_circle_rounded), findsWidgets);
    });
  });

  group('MyItemsPage - Layout', () {
    testWidgets('should have SafeArea', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(SafeArea), findsOneWidget);
    });

    testWidgets('should have Column layout', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('should have Row for header', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(Row), findsWidgets);
    });
  });

  group('MyItemsPage - Tab Icons', () {
    testWidgets('should display search_off icon in Lost tab', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.search_off_rounded), findsWidgets);
    });

    testWidgets('should display check_circle icon in Found tab', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check_circle_rounded), findsWidgets);
    });
  });

  group('MyItemsPage - Item Counts', () {
    testWidgets('should display count badges', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Count badges showing 0
      expect(find.text('0'), findsWidgets);
    });
  });
}
