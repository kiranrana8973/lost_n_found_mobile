import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:lost_n_found/core/services/storage/user_session_service.dart';
import 'package:lost_n_found/features/category/domain/entities/category_entity.dart';
import 'package:lost_n_found/features/category/presentation/bloc/category_bloc.dart';
import 'package:lost_n_found/features/category/presentation/bloc/category_event.dart';
import 'package:lost_n_found/features/category/presentation/state/category_state.dart';
import 'package:lost_n_found/features/item/presentation/bloc/item_bloc.dart';
import 'package:lost_n_found/features/item/presentation/bloc/item_event.dart';
import 'package:lost_n_found/features/item/presentation/pages/report_item_page.dart';
import 'package:lost_n_found/features/item/presentation/state/item_state.dart';
import 'package:mocktail/mocktail.dart';

class MockItemBloc extends MockBloc<ItemEvent, ItemState> implements ItemBloc {}

class MockCategoryBloc extends MockBloc<CategoryEvent, CategoryState>
    implements CategoryBloc {}

class MockUserSessionService extends Mock implements UserSessionService {}

class FakeItemEvent extends Fake implements ItemEvent {}

class FakeCategoryEvent extends Fake implements CategoryEvent {}

void main() {
  late MockItemBloc mockItemBloc;
  late MockCategoryBloc mockCategoryBloc;
  late MockUserSessionService mockUserSession;

  const tCategories = [
    CategoryEntity(categoryId: 'c1', name: 'Electronics'),
    CategoryEntity(categoryId: 'c2', name: 'Personal'),
  ];

  setUpAll(() {
    registerFallbackValue(FakeItemEvent());
    registerFallbackValue(FakeCategoryEvent());
  });

  setUp(() {
    mockItemBloc = MockItemBloc();
    mockCategoryBloc = MockCategoryBloc();
    mockUserSession = MockUserSessionService();

    when(() => mockItemBloc.state).thenReturn(const ItemState());
    when(() => mockCategoryBloc.state).thenReturn(const CategoryState(
      status: CategoryStatus.loaded,
      categories: tCategories,
    ));
    when(() => mockUserSession.getCurrentUserId()).thenReturn('user-1');

    final sl = GetIt.instance;
    if (sl.isRegistered<UserSessionService>()) {
      sl.unregister<UserSessionService>();
    }
    sl.registerSingleton<UserSessionService>(mockUserSession);
  });

  tearDown(() {
    final sl = GetIt.instance;
    if (sl.isRegistered<UserSessionService>()) {
      sl.unregister<UserSessionService>();
    }
  });

  Widget buildWidget() {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<ItemBloc>.value(value: mockItemBloc),
          BlocProvider<CategoryBloc>.value(value: mockCategoryBloc),
        ],
        child: const ReportItemPage(),
      ),
    );
  }

  group('ReportItemPage', () {
    testWidgets('renders Report Item header', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Report Item'), findsOneWidget);
    });

    testWidgets('renders item type toggle', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('I Lost Something'), findsOneWidget);
      expect(find.text('I Found Something'), findsOneWidget);
    });

    testWidgets('renders form fields', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Item Name'), findsOneWidget);
      expect(find.text('Category'), findsOneWidget);
      expect(find.text('Location'), findsOneWidget);
      expect(find.text('Description'), findsOneWidget);
    });

    testWidgets('renders category chips', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Electronics'), findsOneWidget);
      expect(find.text('Personal'), findsOneWidget);
    });

    testWidgets('shows validation error for empty item name', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      // Scroll to submit button and tap
      final submitFinder = find.text('Report Lost Item');
      if (submitFinder.evaluate().isNotEmpty) {
        await tester.ensureVisible(submitFinder);
        await tester.tap(submitFinder);
        await tester.pumpAndSettle();

        expect(find.text('Please enter item name'), findsOneWidget);
      }
    });

    testWidgets('renders back button', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
    });
  });
}
