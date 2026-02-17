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
import 'package:lost_n_found/features/dashboard/presentation/pages/profile_screen.dart';
import 'package:lost_n_found/features/item/presentation/bloc/item_bloc.dart';
import 'package:lost_n_found/features/item/presentation/bloc/item_event.dart';
import 'package:lost_n_found/features/item/presentation/state/item_state.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockItemBloc extends MockBloc<ItemEvent, ItemState> implements ItemBloc {}

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

class MockUserSessionService extends Mock implements UserSessionService {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

class FakeItemEvent extends Fake implements ItemEvent {}

class FakeAuthEvent extends Fake implements AuthEvent {}

void main() {
  late MockItemBloc mockItemBloc;
  late MockAuthBloc mockAuthBloc;
  late MockUserSessionService mockUserSession;
  late MockSharedPreferences mockPrefs;

  setUpAll(() {
    registerFallbackValue(FakeItemEvent());
    registerFallbackValue(FakeAuthEvent());
  });

  setUp(() {
    mockItemBloc = MockItemBloc();
    mockAuthBloc = MockAuthBloc();
    mockUserSession = MockUserSessionService();
    mockPrefs = MockSharedPreferences();

    when(() => mockItemBloc.state).thenReturn(const ItemState());
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
          BlocProvider<AuthBloc>.value(value: mockAuthBloc),
          BlocProvider<ThemeCubit>(create: (_) => ThemeCubit(prefs: mockPrefs)),
        ],
        child: const ProfileScreen(),
      ),
    );
  }

  group('ProfileScreen', () {
    testWidgets('renders user info', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Test User'), findsOneWidget);
      expect(find.text('test@test.com'), findsOneWidget);
    });

    testWidgets('renders all menu items', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Edit Profile'), findsOneWidget);
      expect(find.text('My Items'), findsOneWidget);
      expect(find.text('Notifications'), findsOneWidget);
      expect(find.text('Privacy & Security'), findsOneWidget);
      expect(find.text('Help & Support'), findsOneWidget);
      expect(find.text('About'), findsOneWidget);
      expect(find.text('Logout'), findsOneWidget);
    });

    testWidgets('renders version text', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Version 1.0.0'), findsOneWidget);
    });

    testWidgets('shows logout confirmation dialog', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Logout'));
      await tester.tap(find.text('Logout'));
      await tester.pumpAndSettle();

      expect(find.text('Are you sure you want to logout?'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('cancel button dismisses logout dialog', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Logout'));
      await tester.tap(find.text('Logout'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.text('Are you sure you want to logout?'), findsNothing);
    });
  });
}
