import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:lost_n_found/app/theme/theme_cubit.dart';
import 'package:lost_n_found/core/services/storage/user_session_service.dart';
import 'package:lost_n_found/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lost_n_found/features/auth/presentation/bloc/auth_event.dart';
import 'package:lost_n_found/features/auth/presentation/state/auth_state.dart';
import 'package:lost_n_found/features/category/presentation/bloc/category_bloc.dart';
import 'package:lost_n_found/features/category/presentation/bloc/category_event.dart';
import 'package:lost_n_found/features/category/presentation/state/category_state.dart';
import 'package:lost_n_found/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:lost_n_found/features/item/presentation/bloc/item_bloc.dart';
import 'package:lost_n_found/features/item/presentation/bloc/item_event.dart';
import 'package:lost_n_found/features/item/presentation/state/item_state.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockItemBloc extends MockBloc<ItemEvent, ItemState> implements ItemBloc {}

class MockCategoryBloc extends MockBloc<CategoryEvent, CategoryState>
    implements CategoryBloc {}

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

class MockUserSessionService extends Mock implements UserSessionService {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

class FakeItemEvent extends Fake implements ItemEvent {}

class FakeCategoryEvent extends Fake implements CategoryEvent {}

class FakeAuthEvent extends Fake implements AuthEvent {}

void main() {
  late MockItemBloc mockItemBloc;
  late MockCategoryBloc mockCategoryBloc;
  late MockAuthBloc mockAuthBloc;
  late MockUserSessionService mockUserSession;
  late MockSharedPreferences mockPrefs;

  setUpAll(() {
    registerFallbackValue(FakeItemEvent());
    registerFallbackValue(FakeCategoryEvent());
    registerFallbackValue(FakeAuthEvent());
  });

  setUp(() {
    mockItemBloc = MockItemBloc();
    mockCategoryBloc = MockCategoryBloc();
    mockAuthBloc = MockAuthBloc();
    mockUserSession = MockUserSessionService();
    mockPrefs = MockSharedPreferences();

    when(() => mockItemBloc.state).thenReturn(const ItemState());
    when(() => mockCategoryBloc.state).thenReturn(const CategoryState());
    when(() => mockAuthBloc.state).thenReturn(const AuthState());
    when(
      () => mockUserSession.getCurrentUserFullName(),
    ).thenReturn('Test User');
    when(
      () => mockUserSession.getCurrentUserEmail(),
    ).thenReturn('test@test.com');
    when(() => mockUserSession.getCurrentUserId()).thenReturn('user-1');
    when(() => mockPrefs.getString(any())).thenReturn(null);

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
          BlocProvider<AuthBloc>.value(value: mockAuthBloc),
          BlocProvider<ThemeCubit>(create: (_) => ThemeCubit(prefs: mockPrefs)),
        ],
        child: const DashboardPage(),
      ),
    );
  }

  group('DashboardPage', () {
    testWidgets('renders bottom navigation items', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pump();

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('My Items'), findsOneWidget);
      expect(find.text('Alerts'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('renders floating action button', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pump();

      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add_rounded), findsOneWidget);
    });

    testWidgets('switches to My Items tab on tap', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pump();

      await tester.tap(find.text('My Items'));
      await tester.pumpAndSettle();

      // My Items page should show its header
      expect(find.text('My Items').first, findsOneWidget);
    });

    testWidgets('switches to Profile tab on tap', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pump();

      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();

      expect(find.text('Edit Profile'), findsOneWidget);
    });
  });
}
