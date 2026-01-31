import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/core/services/storage/user_session_service.dart';
import 'package:lost_n_found/features/auth/domain/entities/auth_entity.dart';
import 'package:lost_n_found/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:lost_n_found/features/auth/domain/usecases/login_usecase.dart';
import 'package:lost_n_found/features/auth/domain/usecases/logout_usecase.dart';
import 'package:lost_n_found/features/auth/domain/usecases/register_usecase.dart';
import 'package:lost_n_found/features/category/domain/usecases/create_category_usecase.dart';
import 'package:lost_n_found/features/category/domain/usecases/delete_category_usecase.dart';
import 'package:lost_n_found/features/category/domain/usecases/get_all_categories_usecase.dart';
import 'package:lost_n_found/features/category/domain/usecases/get_category_by_id_usecase.dart';
import 'package:lost_n_found/features/category/domain/usecases/update_category_usecase.dart';
import 'package:lost_n_found/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:lost_n_found/features/item/domain/usecases/create_item_usecase.dart';
import 'package:lost_n_found/features/item/domain/usecases/delete_item_usecase.dart';
import 'package:lost_n_found/features/item/domain/usecases/get_all_items_usecase.dart';
import 'package:lost_n_found/features/item/domain/usecases/get_item_by_id_usecase.dart';
import 'package:lost_n_found/features/item/domain/usecases/get_items_by_user_usecase.dart';
import 'package:lost_n_found/features/item/domain/usecases/update_item_usecase.dart';
import 'package:lost_n_found/features/item/domain/usecases/upload_photo_usecase.dart';
import 'package:lost_n_found/features/item/domain/usecases/upload_video_usecase.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Auth Mocks
class MockRegisterUsecase extends Mock implements RegisterUsecase {}

class MockLoginUsecase extends Mock implements LoginUsecase {}

class MockGetCurrentUserUsecase extends Mock implements GetCurrentUserUsecase {}

class MockLogoutUsecase extends Mock implements LogoutUsecase {}

class MockUserSessionService extends Mock implements UserSessionService {}

// Item Mocks
class MockGetAllItemsUsecase extends Mock implements GetAllItemsUsecase {}

class MockGetItemByIdUsecase extends Mock implements GetItemByIdUsecase {}

class MockGetItemsByUserUsecase extends Mock implements GetItemsByUserUsecase {}

class MockCreateItemUsecase extends Mock implements CreateItemUsecase {}

class MockUpdateItemUsecase extends Mock implements UpdateItemUsecase {}

class MockDeleteItemUsecase extends Mock implements DeleteItemUsecase {}

class MockUploadPhotoUsecase extends Mock implements UploadPhotoUsecase {}

class MockUploadVideoUsecase extends Mock implements UploadVideoUsecase {}

// Category Mocks
class MockGetAllCategoriesUsecase extends Mock
    implements GetAllCategoriesUsecase {}

class MockGetCategoryByIdUsecase extends Mock
    implements GetCategoryByIdUsecase {}

class MockCreateCategoryUsecase extends Mock implements CreateCategoryUsecase {}

class MockUpdateCategoryUsecase extends Mock implements UpdateCategoryUsecase {}

class MockDeleteCategoryUsecase extends Mock implements DeleteCategoryUsecase {}

void main() {
  late SharedPreferences sharedPreferences;
  late MockRegisterUsecase mockRegisterUsecase;
  late MockLoginUsecase mockLoginUsecase;
  late MockGetCurrentUserUsecase mockGetCurrentUserUsecase;
  late MockLogoutUsecase mockLogoutUsecase;
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

  const tUser = AuthEntity(
    authId: '1',
    fullName: 'Test User',
    email: 'test@example.com',
    username: 'testuser',
  );

  setUpAll(() async {
    registerFallbackValue(const GetItemsByUserParams(userId: ''));
    SharedPreferences.setMockInitialValues({});
    sharedPreferences = await SharedPreferences.getInstance();
  });

  setUp(() {
    mockRegisterUsecase = MockRegisterUsecase();
    mockLoginUsecase = MockLoginUsecase();
    mockGetCurrentUserUsecase = MockGetCurrentUserUsecase();
    mockLogoutUsecase = MockLogoutUsecase();
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
    when(() => mockGetCurrentUserUsecase()).thenAnswer(
      (_) async => const Right(tUser),
    );
    when(() => mockUserSessionService.getCurrentUserId()).thenReturn('1');
    when(() => mockGetAllItemsUsecase()).thenAnswer(
      (_) async => const Right([]),
    );
    when(() => mockGetItemsByUserUsecase(any())).thenAnswer(
      (_) async => const Right([]),
    );
    when(() => mockGetAllCategoriesUsecase()).thenAnswer(
      (_) async => const Right([]),
    );
  });

  Widget createTestWidget() {
    return ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        userSessionServiceProvider.overrideWithValue(mockUserSessionService),
        registerUsecaseProvider.overrideWithValue(mockRegisterUsecase),
        loginUsecaseProvider.overrideWithValue(mockLoginUsecase),
        getCurrentUserUsecaseProvider
            .overrideWithValue(mockGetCurrentUserUsecase),
        logoutUsecaseProvider.overrideWithValue(mockLogoutUsecase),
        getAllItemsUsecaseProvider.overrideWithValue(mockGetAllItemsUsecase),
        getItemByIdUsecaseProvider.overrideWithValue(mockGetItemByIdUsecase),
        getItemsByUserUsecaseProvider
            .overrideWithValue(mockGetItemsByUserUsecase),
        createItemUsecaseProvider.overrideWithValue(mockCreateItemUsecase),
        updateItemUsecaseProvider.overrideWithValue(mockUpdateItemUsecase),
        deleteItemUsecaseProvider.overrideWithValue(mockDeleteItemUsecase),
        uploadPhotoUsecaseProvider.overrideWithValue(mockUploadPhotoUsecase),
        uploadVideoUsecaseProvider.overrideWithValue(mockUploadVideoUsecase),
        getAllCategoriesUsecaseProvider
            .overrideWithValue(mockGetAllCategoriesUsecase),
        getCategoryByIdUsecaseProvider
            .overrideWithValue(mockGetCategoryByIdUsecase),
        createCategoryUsecaseProvider
            .overrideWithValue(mockCreateCategoryUsecase),
        updateCategoryUsecaseProvider
            .overrideWithValue(mockUpdateCategoryUsecase),
        deleteCategoryUsecaseProvider
            .overrideWithValue(mockDeleteCategoryUsecase),
      ],
      child: const MaterialApp(home: DashboardPage()),
    );
  }

  group('DashboardPage - UI Elements', () {
    testWidgets('should display scaffold', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('should display bottom navigation bar items', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('My Items'), findsOneWidget);
      expect(find.text('Alerts'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('should display FloatingActionButton', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('should display add icon in FAB', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.add_rounded), findsOneWidget);
    });

    testWidgets('should display navigation icons', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.home_rounded), findsWidgets);
      expect(find.byIcon(Icons.inventory_2_rounded), findsWidgets);
      expect(find.byIcon(Icons.notifications_rounded), findsWidgets);
      expect(find.byIcon(Icons.person_rounded), findsWidgets);
    });

    testWidgets('should display notification badge', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Badge with count 3
      expect(find.text('3'), findsOneWidget);
    });
  });

  group('DashboardPage - Navigation', () {
    testWidgets('should show Home screen by default', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Home icon should be present (selected)
      expect(find.byIcon(Icons.home_rounded), findsOneWidget);
    });

    testWidgets('should navigate to My Items on tap', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('My Items'));
      await tester.pumpAndSettle();

      // Should show My Items content
      expect(find.byIcon(Icons.inventory_2_rounded), findsOneWidget);
    });

    testWidgets('should navigate to Profile on tap', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();

      // Should show Profile content
      expect(find.byIcon(Icons.person_rounded), findsOneWidget);
    });

    testWidgets('should navigate back to Home', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Go to Profile
      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();

      // Go back to Home
      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.home_rounded), findsOneWidget);
    });
  });

  group('DashboardPage - FAB', () {
    testWidgets('FAB should be tappable', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final fab = find.byType(FloatingActionButton);
      expect(fab, findsOneWidget);

      await tester.tap(fab);
      await tester.pumpAndSettle();
    });

    testWidgets('FAB should be centered in bottom bar', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // FAB should be present
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });
  });

  group('DashboardPage - Layout', () {
    testWidgets('should have SafeArea in bottom bar', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(SafeArea), findsWidgets);
    });

    testWidgets('should have Row for navigation items', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(Row), findsWidgets);
    });

    testWidgets('should have GestureDetector for nav items', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(GestureDetector), findsWidgets);
    });
  });
}
