import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lost_n_found/features/auth/presentation/bloc/auth_event.dart';
import 'package:lost_n_found/features/auth/presentation/pages/login_page.dart';
import 'package:lost_n_found/features/auth/presentation/state/auth_state.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

class FakeAuthEvent extends Fake implements AuthEvent {}

class FakeAuthState extends Fake implements AuthState {}

void main() {
  late MockAuthBloc mockAuthBloc;

  setUpAll(() {
    registerFallbackValue(FakeAuthEvent());
    registerFallbackValue(FakeAuthState());
  });

  setUp(() {
    mockAuthBloc = MockAuthBloc();
    when(() => mockAuthBloc.state).thenReturn(const AuthState());
  });

  Widget buildWidget() {
    return MaterialApp(
      home: BlocProvider<AuthBloc>.value(
        value: mockAuthBloc,
        child: const LoginPage(),
      ),
    );
  }

  group('LoginPage', () {
    testWidgets('renders login page with all key elements', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildWidget());

      expect(find.text('Welcome Back!'), findsOneWidget);
      expect(find.text('Sign in to continue'), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
      expect(find.text('Forgot Password?'), findsOneWidget);
      expect(find.text('OR'), findsOneWidget);
    });

    testWidgets('shows email validation error when empty', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildWidget());

      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter your email'), findsOneWidget);
    });

    testWidgets('shows email validation error for invalid email', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildWidget());

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'invalid-email',
      );
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('shows password validation error when empty', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildWidget());

      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter your password'), findsOneWidget);
    });

    testWidgets('shows password validation error for short password', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildWidget());

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'test@test.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        '12345',
      );
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      expect(
        find.text('Password must be at least 6 characters'),
        findsOneWidget,
      );
    });

    testWidgets('dispatches AuthLoginEvent when form is valid', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildWidget());

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'test@test.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'password123',
      );
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      verify(
        () => mockAuthBloc.add(
          const AuthLoginEvent(email: 'test@test.com', password: 'password123'),
        ),
      ).called(1);
    });

    testWidgets('shows loading indicator when auth is loading', (
      WidgetTester tester,
    ) async {
      when(
        () => mockAuthBloc.state,
      ).thenReturn(const AuthState(status: AuthStatus.loading));

      await tester.pumpWidget(buildWidget());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      // Login button should be disabled
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('toggles password visibility', (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget());

      // Initially password is obscured - check via EditableText
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);

      // Tap visibility toggle
      await tester.tap(find.byIcon(Icons.visibility_outlined));
      await tester.pumpAndSettle();

      // Icon should now be visibility_off
      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
    });
  });
}
