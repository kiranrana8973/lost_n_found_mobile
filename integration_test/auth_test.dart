import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:lost_n_found/core/services/hive/hive_service.dart';
import 'package:lost_n_found/core/services/storage/user_session_service.dart';
import 'package:lost_n_found/features/auth/presentation/pages/login_page.dart';
import 'package:lost_n_found/features/auth/presentation/pages/signup_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Auth Integration Tests', () {
    late SharedPreferences sharedPreferences;

    setUpAll(() async {
      await HiveService().init();
      SharedPreferences.setMockInitialValues({});
      sharedPreferences = await SharedPreferences.getInstance();
    });

    group('Login Page Integration Tests', () {
      Widget createLoginPage() {
        return ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(sharedPreferences),
          ],
          child: const MaterialApp(home: LoginPage()),
        );
      }

      testWidgets('Login page should display all UI elements', (tester) async {
        await tester.pumpWidget(createLoginPage());
        await tester.pumpAndSettle();

        // Verify welcome text
        expect(find.text('Welcome Back!'), findsOneWidget);
        expect(find.text('Sign in to continue'), findsOneWidget);

        // Verify form fields
        expect(find.text('Email'), findsOneWidget);
        expect(find.text('Password'), findsOneWidget);
        expect(find.byType(TextFormField), findsNWidgets(2));

        // Verify buttons
        expect(find.text('Login'), findsOneWidget);
        expect(find.text('Forgot Password?'), findsOneWidget);
        expect(find.text('Sign Up'), findsOneWidget);
      });

      testWidgets('Login page should allow text entry', (tester) async {
        await tester.pumpWidget(createLoginPage());
        await tester.pumpAndSettle();

        // Enter email
        await tester.enterText(
          find.byType(TextFormField).first,
          'test@example.com',
        );
        await tester.pump();
        expect(find.text('test@example.com'), findsOneWidget);

        // Enter password
        await tester.enterText(find.byType(TextFormField).last, 'password123');
        await tester.pump();

        // Verify password field has content
        final passwordField = tester.widget<TextFormField>(
          find.byType(TextFormField).last,
        );
        expect(passwordField.controller?.text, 'password123');
      });

      testWidgets('Login page should toggle password visibility', (
        tester,
      ) async {
        await tester.pumpWidget(createLoginPage());
        await tester.pumpAndSettle();

        // Initially password is hidden
        expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);

        // Tap to show password
        await tester.tap(find.byIcon(Icons.visibility_outlined));
        await tester.pump();

        // Password is now visible
        expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
      });

      testWidgets('Login page should show validation errors', (tester) async {
        await tester.pumpWidget(createLoginPage());
        await tester.pumpAndSettle();

        // Tap login without entering anything
        await tester.tap(find.text('Login'));
        await tester.pump();

        // Should show email error
        expect(find.text('Please enter your email'), findsOneWidget);
      });

      testWidgets('Login page should validate email format', (tester) async {
        await tester.pumpWidget(createLoginPage());
        await tester.pumpAndSettle();

        // Enter invalid email
        await tester.enterText(
          find.byType(TextFormField).first,
          'invalidemail',
        );
        await tester.enterText(find.byType(TextFormField).last, 'password123');
        await tester.tap(find.text('Login'));
        await tester.pump();

        // Should show invalid email error
        expect(find.text('Please enter a valid email'), findsOneWidget);
      });

      testWidgets('Login page should validate password length', (tester) async {
        await tester.pumpWidget(createLoginPage());
        await tester.pumpAndSettle();

        // Enter valid email but short password
        await tester.enterText(
          find.byType(TextFormField).first,
          'test@example.com',
        );
        await tester.enterText(find.byType(TextFormField).last, '12345');
        await tester.tap(find.text('Login'));
        await tester.pump();

        // Should show password length error
        expect(
          find.text('Password must be at least 6 characters'),
          findsOneWidget,
        );
      });
    });

    group('Signup Page Integration Tests', () {
      Widget createSignupPage() {
        return ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(sharedPreferences),
          ],
          child: const MaterialApp(home: SignupPage()),
        );
      }

      testWidgets('Signup page should display all UI elements', (tester) async {
        await tester.pumpWidget(createSignupPage());
        await tester.pumpAndSettle();

        // Verify header
        expect(find.text('Join Us Today'), findsOneWidget);
        expect(find.text('Create your account to get started'), findsOneWidget);

        // Verify form fields
        expect(find.text('Full Name'), findsOneWidget);
        expect(find.text('Email Address'), findsOneWidget);
        expect(find.text('Phone Number'), findsOneWidget);
        expect(find.text('Select Batch'), findsOneWidget);

        // Verify buttons
        expect(find.text('Create Account'), findsOneWidget);
        expect(find.text('Login'), findsOneWidget);
      });

      testWidgets('Signup page should allow text entry in name field', (
        tester,
      ) async {
        await tester.pumpWidget(createSignupPage());
        await tester.pumpAndSettle();

        // Enter name
        await tester.enterText(find.byType(TextFormField).first, 'John Doe');
        await tester.pump();

        expect(find.text('John Doe'), findsOneWidget);
      });

      testWidgets('Signup page should have back button', (tester) async {
        await tester.pumpWidget(createSignupPage());
        await tester.pumpAndSettle();

        // Back button should be in app bar
        expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      });

      testWidgets('Signup page should display country code dropdown', (
        tester,
      ) async {
        await tester.pumpWidget(createSignupPage());
        await tester.pumpAndSettle();

        // Country code dropdown
        expect(find.text('Code'), findsOneWidget);
      });

      testWidgets('Signup page should have terms checkbox', (tester) async {
        await tester.pumpWidget(createSignupPage());
        await tester.pumpAndSettle();

        // Terms checkbox
        expect(find.byType(Checkbox), findsOneWidget);
      });

      testWidgets('Signup page should toggle terms checkbox', (tester) async {
        await tester.pumpWidget(createSignupPage());
        await tester.pumpAndSettle();

        // Find checkbox
        final checkbox = find.byType(Checkbox);

        // Initially unchecked
        Checkbox checkboxWidget = tester.widget(checkbox);
        expect(checkboxWidget.value, false);

        // Tap to check
        await tester.tap(checkbox);
        await tester.pump();

        // Now checked
        checkboxWidget = tester.widget(checkbox);
        expect(checkboxWidget.value, true);
      });
    });
  });
}
