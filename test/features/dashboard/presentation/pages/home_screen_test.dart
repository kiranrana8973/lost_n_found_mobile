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
import 'package:lost_n_found/features/dashboard/presentation/pages/home_screen.dart';
import 'package:lost_n_found/features/item/domain/entities/item_entity.dart';
import 'package:lost_n_found/features/item/presentation/bloc/item_bloc.dart';
import 'package:lost_n_found/features/item/presentation/bloc/item_event.dart';
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

  const tItems = [
    ItemEntity(
      itemId: 'i1',
      itemName: 'Lost Wallet',
      type: ItemType.lost,
      location: 'Library',
    ),
    ItemEntity(
      itemId: 'i2',
      itemName: 'Found Phone',
      type: ItemType.found,
      location: 'Cafeteria',
    ),
  ];

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

    when(() => mockItemBloc.state).thenReturn(
      const ItemState(
        status: ItemStatus.loaded,
        items: tItems,
        lostItems: [
          ItemEntity(
            itemId: 'i1',
            itemName: 'Lost Wallet',
            type: ItemType.lost,
            location: 'Library',
          ),
        ],
        foundItems: [
          ItemEntity(
            itemId: 'i2',
            itemName: 'Found Phone',
            type: ItemType.found,
            location: 'Cafeteria',
          ),
        ],
      ),
    );
    when(() => mockCategoryBloc.state).thenReturn(
      const CategoryState(
        status: CategoryStatus.loaded,
        categories: tCategories,
      ),
    );
    when(
      () => mockUserSession.getCurrentUserFullName(),
    ).thenReturn('Test User');

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
        child: const HomeScreen(),
      ),
    );
  }

  group('HomeScreen', () {
    testWidgets('renders greeting with user name', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pump();

      expect(find.textContaining('Test User'), findsOneWidget);
    });

    testWidgets('renders filter tabs', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pump();

      expect(find.text('All'), findsAtLeast(1));
      expect(find.text('Lost'), findsAtLeast(1));
      expect(find.text('Found'), findsAtLeast(1));
    });

    testWidgets('renders stat cards with counts', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pump();

      expect(find.text('Lost Items'), findsOneWidget);
      expect(find.text('Found Items'), findsOneWidget);
      expect(find.text('1'), findsNWidgets(2)); // 1 lost, 1 found
    });

    testWidgets('renders Recent Items section', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pump();

      expect(find.text('Recent Items'), findsOneWidget);
      expect(find.text('See All'), findsOneWidget);
    });

    testWidgets('renders item cards', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pump();

      expect(find.text('Lost Wallet'), findsOneWidget);
      // Scroll down to find the second item card
      await tester.scrollUntilVisible(
        find.text('Found Phone'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Found Phone'), findsOneWidget);
    });

    testWidgets('renders category chips', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pump();

      expect(find.text('Electronics'), findsOneWidget);
      expect(find.text('Personal'), findsOneWidget);
    });

    testWidgets('shows loading indicator when loading', (tester) async {
      when(
        () => mockItemBloc.state,
      ).thenReturn(const ItemState(status: ItemStatus.loading));

      await tester.pumpWidget(buildWidget());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
