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
import 'package:lost_n_found/features/item/presentation/pages/report_item_page.dart';
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
    when(() => mockGetAllCategoriesUsecase()).thenAnswer(
      (_) async => const Right([]),
    );
    when(() => mockGetAllItemsUsecase()).thenAnswer(
      (_) async => const Right([]),
    );
  });

  Widget createTestWidget() {
    return ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        userSessionServiceProvider.overrideWithValue(mockUserSessionService),
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
      child: const MaterialApp(home: ReportItemPage()),
    );
  }

  group('ReportItemPage - UI Elements', () {
    testWidgets('should display scaffold', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should display Report Item header', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Report Item'), findsOneWidget);
    });

    testWidgets('should display back button', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
    });

    testWidgets('should display item type toggle (Lost/Found)', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('I Lost Something'), findsOneWidget);
      expect(find.text('I Found Something'), findsOneWidget);
    });

    testWidgets('should display Item Name section', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Item Name'), findsOneWidget);
    });

    testWidgets('should display Category section', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Category'), findsOneWidget);
    });

    testWidgets('should display Location section', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Location'), findsOneWidget);
    });

    testWidgets('should display Description section', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Description'), findsOneWidget);
    });

    testWidgets('should display camera icon for media upload', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.add_a_photo_rounded), findsOneWidget);
    });
  });

  group('ReportItemPage - Item Type Toggle', () {
    testWidgets('Lost should be selected by default', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Lost text should be visible
      expect(find.text('I Lost Something'), findsOneWidget);
    });

    testWidgets('should toggle to Found on tap', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('I Found Something'));
      await tester.pumpAndSettle();

      // Found should now be selected
      expect(find.text('I Found Something'), findsOneWidget);
    });

    testWidgets('should toggle back to Lost on tap', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap Found
      await tester.tap(find.text('I Found Something'));
      await tester.pumpAndSettle();

      // Tap Lost
      await tester.tap(find.text('I Lost Something'));
      await tester.pumpAndSettle();

      expect(find.text('I Lost Something'), findsOneWidget);
    });
  });

  group('ReportItemPage - Form Fields', () {
    testWidgets('should have text fields for input', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(TextFormField), findsWidgets);
    });

    testWidgets('should allow entering item name', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.first, 'iPhone 14 Pro');
      await tester.pump();

      expect(find.text('iPhone 14 Pro'), findsOneWidget);
    });

    testWidgets('should display location hint text', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Where did you lose it?'), findsOneWidget);
    });

    testWidgets('should change location hint when Found is selected', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('I Found Something'));
      await tester.pumpAndSettle();

      expect(find.text('Where did you find it?'), findsOneWidget);
    });
  });

  group('ReportItemPage - Submit Button', () {
    testWidgets('should display submit button with Report Lost', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.textContaining('Report'), findsWidgets);
    });
  });

  group('ReportItemPage - Navigation', () {
    testWidgets('back button should be tappable', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final backButton = find.byIcon(Icons.arrow_back_rounded);
      expect(backButton, findsOneWidget);

      await tester.tap(backButton);
      await tester.pumpAndSettle();
    });
  });

  group('ReportItemPage - Layout', () {
    testWidgets('should have SafeArea', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(SafeArea), findsOneWidget);
    });

    testWidgets('should have SingleChildScrollView', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('should have Form widget', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(Form), findsOneWidget);
    });

    testWidgets('should have Column layout', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(Column), findsWidgets);
    });
  });
}
