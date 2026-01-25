import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/features/auth/domain/entities/auth_entity.dart';
import 'package:lost_n_found/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:lost_n_found/features/auth/domain/usecases/login_usecase.dart';
import 'package:lost_n_found/features/auth/domain/usecases/logout_usecase.dart';
import 'package:lost_n_found/features/auth/domain/usecases/register_usecase.dart';
import 'package:lost_n_found/features/auth/presentation/pages/login_page.dart';
import 'package:mocktail/mocktail.dart';

// Mock NavigatorObserver to track navigation
class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockRegisterUsecase extends Mock implements RegisterUsecase {}

class MockLoginUsecase extends Mock implements LoginUsecase {}

class MockGetCurrentUserUsecase extends Mock implements GetCurrentUserUsecase {}

class MockLogoutUsecase extends Mock implements LogoutUsecase {}

void main() {
  late MockRegisterUsecase mockRegisterUsecase;
  late MockLoginUsecase mockLoginUsecase;
  late MockGetCurrentUserUsecase mockGetCurrentUserUsecase;
  late MockLogoutUsecase mockLogoutUsecase;

  setUpAll(() {
    registerFallbackValue(
      const RegisterParams(
        fullName: 'fallback',
        email: 'fallback@email.com',
        username: 'fallback',
        password: 'fallback',
      ),
    );
    registerFallbackValue(
      const LoginParams(email: 'fallback@email.com', password: 'fallback'),
    );
  });

  setUp(() {
    mockRegisterUsecase = MockRegisterUsecase();
    mockLoginUsecase = MockLoginUsecase();
    mockGetCurrentUserUsecase = MockGetCurrentUserUsecase();
    mockLogoutUsecase = MockLogoutUsecase();
  });

  Widget createTestWidget() {
    return ProviderScope(
      overrides: [
        registerUsecaseProvider.overrideWithValue(mockRegisterUsecase),
        loginUsecaseProvider.overrideWithValue(mockLoginUsecase),
        getCurrentUserUsecaseProvider.overrideWithValue(
          mockGetCurrentUserUsecase,
        ),
        logoutUsecaseProvider.overrideWithValue(mockLogoutUsecase),
      ],
      child: const MaterialApp(home: LoginPage()),
    );
  }

  group('LoginPage UI Elements', () {
    testWidgets('should display welcome text', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Welcome Back!'), findsOneWidget);
      expect(find.text('Sign in to continue'), findsOneWidget);
    });

    testWidgets('should display email and password labels', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
    });

    testWidgets('should display login button', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Login'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should display two text form fields', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(TextFormField), findsNWidgets(2));
    });

    testWidgets('should display email icon', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byIcon(Icons.email_outlined), findsOneWidget);
    });

    testWidgets('should display lock icon', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
    });

    testWidgets('should display visibility icon for password', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
    });

    testWidgets('should toggle password visibility', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);

      await tester.tap(find.byIcon(Icons.visibility_outlined));
      await tester.pump();

      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
    });

    testWidgets('should display forgot password button', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Forgot Password?'), findsOneWidget);
    });

    testWidgets('should display signup link text', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text("Don't have an account? "), findsOneWidget);
      expect(find.text('Sign Up'), findsOneWidget);
    });

    testWidgets('should display OR divider', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('OR'), findsOneWidget);
    });

    testWidgets('should display hint texts', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Enter your email'), findsOneWidget);
      expect(find.text('Enter your password'), findsOneWidget);
    });
  });

  group('LoginPage Form Validation', () {
    testWidgets('should show error for empty email', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(find.byType(TextFormField).last, 'password123');
      await tester.tap(find.text('Login'));
      await tester.pump();

      expect(find.text('Please enter your email'), findsOneWidget);
    });

    testWidgets('should show error for invalid email', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(find.byType(TextFormField).first, 'invalidemail');
      await tester.enterText(find.byType(TextFormField).last, 'password123');
      await tester.tap(find.text('Login'));
      await tester.pump();

      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('should show error for empty password', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(
        find.byType(TextFormField).first,
        'test@example.com',
      );
      await tester.tap(find.text('Login'));
      await tester.pump();

      expect(find.text('Please enter your password'), findsOneWidget);
    });

    testWidgets('should show error for short password', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(
        find.byType(TextFormField).first,
        'test@example.com',
      );
      await tester.enterText(find.byType(TextFormField).last, '12345');
      await tester.tap(find.text('Login'));
      await tester.pump();

      expect(
        find.text('Password must be at least 6 characters'),
        findsOneWidget,
      );
    });

    testWidgets('should allow text entry in email field', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(
        find.byType(TextFormField).first,
        'test@example.com',
      );
      await tester.pump();

      expect(find.text('test@example.com'), findsOneWidget);
    });

    testWidgets('should allow text entry in password field', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(find.byType(TextFormField).last, 'password123');
      await tester.pump();

      // Password is obscured, so we verify by checking the field has content
      final passwordField = tester.widget<TextFormField>(
        find.byType(TextFormField).last,
      );
      expect(passwordField.controller?.text, 'password123');
    });
  });

  group('LoginPage Form Submission', () {
    testWidgets('should call login usecase when form is valid', (tester) async {
      // Arrange - Mock login to return a user (use completer to control timing)
      final completer = Completer<Either<Failure, AuthEntity>>();

      when(() => mockLoginUsecase(any())).thenAnswer((_) => completer.future);

      await tester.pumpWidget(createTestWidget());

      // Fill form fields
      await tester.enterText(
        find.byType(TextFormField).first,
        'test@example.com',
      );
      await tester.enterText(find.byType(TextFormField).last, 'password123');

      // Tap login button
      await tester.tap(find.text('Login'));
      await tester.pump();

      // Verify login usecase was called
      verify(() => mockLoginUsecase(any())).called(1);
    });

    testWidgets('should call login with correct email and password', (
      tester,
    ) async {
      // Arrange - Use completer to prevent navigation
      final completer = Completer<Either<Failure, AuthEntity>>();

      LoginParams? capturedParams;
      when(() => mockLoginUsecase(any())).thenAnswer((invocation) {
        capturedParams = invocation.positionalArguments[0] as LoginParams;
        return completer.future;
      });

      await tester.pumpWidget(createTestWidget());

      // Fill form fields
      await tester.enterText(find.byType(TextFormField).first, 'user@test.com');
      await tester.enterText(find.byType(TextFormField).last, 'mypassword');

      // Tap login button
      await tester.tap(find.text('Login'));
      await tester.pump();

      // Verify correct params were passed
      expect(capturedParams?.email, 'user@test.com');
      expect(capturedParams?.password, 'mypassword');
    });

    testWidgets('should not call login usecase when form is invalid', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      // Only fill email (password empty)
      await tester.enterText(
        find.byType(TextFormField).first,
        'test@example.com',
      );

      // Tap login button
      await tester.tap(find.text('Login'));
      await tester.pump();

      // Verify login usecase was NOT called
      verifyNever(() => mockLoginUsecase(any()));
    });

    testWidgets('should show loading indicator while logging in', (
      tester,
    ) async {
      // Arrange - Use completer to keep loading state
      final completer = Completer<Either<Failure, AuthEntity>>();

      when(() => mockLoginUsecase(any())).thenAnswer((_) => completer.future);

      await tester.pumpWidget(createTestWidget());

      // Fill form fields
      await tester.enterText(
        find.byType(TextFormField).first,
        'test@example.com',
      );
      await tester.enterText(find.byType(TextFormField).last, 'password123');

      // Tap login button
      await tester.tap(find.text('Login'));
      await tester.pump(); // Start the login

      // Verify loading indicator is shown
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
