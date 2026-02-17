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
import 'package:lost_n_found/features/item/domain/entities/item_entity.dart';
import 'package:lost_n_found/features/item/presentation/bloc/item_bloc.dart';
import 'package:lost_n_found/features/item/presentation/bloc/item_event.dart';
import 'package:lost_n_found/features/item/presentation/pages/my_items_page.dart';
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

  const tLostItem = ItemEntity(
    itemId: 'i1',
    itemName: 'Lost Wallet',
    type: ItemType.lost,
    location: 'Library',
    category: 'c1',
  );

  const tFoundItem = ItemEntity(
    itemId: 'i2',
    itemName: 'Found Phone',
    type: ItemType.found,
    location: 'Cafeteria',
    category: 'c2',
  );

  setUpAll(() {
    registerFallbackValue(FakeItemEvent());
    registerFallbackValue(FakeCategoryEvent());
  });

  setUp(() {
    mockItemBloc = MockItemBloc();
    mockCategoryBloc = MockCategoryBloc();
    mockUserSession = MockUserSessionService();

    when(() => mockItemBloc.state).thenReturn(const ItemState(
      status: ItemStatus.loaded,
      myLostItems: [tLostItem],
      myFoundItems: [tFoundItem],
    ));
    when(() => mockCategoryBloc.state).thenReturn(const CategoryState(
      status: CategoryStatus.loaded,
      categories: [
        CategoryEntity(categoryId: 'c1', name: 'Electronics'),
        CategoryEntity(categoryId: 'c2', name: 'Personal'),
      ],
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
        child: const MyItemsPage(),
      ),
    );
  }

  group('MyItemsPage', () {
    testWidgets('renders My Items header', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('My Items'), findsOneWidget);
      expect(find.text('Track your reports'), findsOneWidget);
    });

    testWidgets('renders Lost and Found tabs', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Lost'), findsOneWidget);
      expect(find.text('Found'), findsOneWidget);
    });

    testWidgets('shows tab counts', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      // Both tabs show count "1"
      expect(find.text('1'), findsNWidgets(2));
    });

    testWidgets('renders lost items in first tab', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Lost Wallet'), findsOneWidget);
    });

    testWidgets('shows loading indicator when loading', (tester) async {
      when(() => mockItemBloc.state)
          .thenReturn(const ItemState(status: ItemStatus.loading));

      await tester.pumpWidget(buildWidget());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows empty state when no lost items', (tester) async {
      when(() => mockItemBloc.state).thenReturn(const ItemState(
        status: ItemStatus.loaded,
        myLostItems: [],
        myFoundItems: [],
      ));

      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('No lost items reported'), findsOneWidget);
    });
  });
}
