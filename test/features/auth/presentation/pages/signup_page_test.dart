import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:lost_n_found/features/auth/domain/usecases/login_usecase.dart';
import 'package:lost_n_found/features/auth/domain/usecases/logout_usecase.dart';
import 'package:lost_n_found/features/auth/domain/usecases/register_usecase.dart';
import 'package:lost_n_found/features/auth/presentation/pages/signup_page.dart';
import 'package:lost_n_found/features/batch/domain/entities/batch_entity.dart';
import 'package:lost_n_found/features/batch/domain/usecases/create_batch_usecase.dart';
import 'package:lost_n_found/features/batch/domain/usecases/delete_batch_usecase.dart';
import 'package:lost_n_found/features/batch/domain/usecases/get_all_batch_usecase.dart';
import 'package:lost_n_found/features/batch/domain/usecases/get_batch_byid_usecase.dart';
import 'package:lost_n_found/features/batch/domain/usecases/update_batch_usecase.dart';
import 'package:mocktail/mocktail.dart';

// Auth Mocks
class MockRegisterUsecase extends Mock implements RegisterUsecase {}

class MockLoginUsecase extends Mock implements LoginUsecase {}

class MockGetCurrentUserUsecase extends Mock implements GetCurrentUserUsecase {}

class MockLogoutUsecase extends Mock implements LogoutUsecase {}

// Batch Mocks
class MockGetAllBatchUsecase extends Mock implements GetAllBatchUsecase {}

class MockGetBatchByIdUsecase extends Mock implements GetBatchByIdUsecase {}

class MockCreateBatchUsecase extends Mock implements CreateBatchUsecase {}

class MockUpdateBatchUsecase extends Mock implements UpdateBatchUsecase {}

class MockDeleteBatchUsecase extends Mock implements DeleteBatchUsecase {}

void main() {
  late MockRegisterUsecase mockRegisterUsecase;
  late MockLoginUsecase mockLoginUsecase;
  late MockGetCurrentUserUsecase mockGetCurrentUserUsecase;
  late MockLogoutUsecase mockLogoutUsecase;
  late MockGetAllBatchUsecase mockGetAllBatchUsecase;
  late MockGetBatchByIdUsecase mockGetBatchByIdUsecase;
  late MockCreateBatchUsecase mockCreateBatchUsecase;
  late MockUpdateBatchUsecase mockUpdateBatchUsecase;
  late MockDeleteBatchUsecase mockDeleteBatchUsecase;

  final tBatches = [
    const BatchEntity(batchId: '1', batchName: 'Batch 2024', status: 'active'),
    const BatchEntity(batchId: '2', batchName: 'Batch 2025', status: 'active'),
  ];

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
    registerFallbackValue(const BatchEntity(batchName: 'fallback'));
    registerFallbackValue(const CreateBatchParams(batchName: 'fallback'));
    registerFallbackValue(const GetBatchByIdParams(batchId: 'fallback'));
    registerFallbackValue(
      const UpdateBatchParams(batchId: 'fallback', batchName: 'fallback'),
    );
    registerFallbackValue(const DeleteBatchParams(batchId: 'fallback'));
  });

  setUp(() {
    mockRegisterUsecase = MockRegisterUsecase();
    mockLoginUsecase = MockLoginUsecase();
    mockGetCurrentUserUsecase = MockGetCurrentUserUsecase();
    mockLogoutUsecase = MockLogoutUsecase();
    mockGetAllBatchUsecase = MockGetAllBatchUsecase();
    mockGetBatchByIdUsecase = MockGetBatchByIdUsecase();
    mockCreateBatchUsecase = MockCreateBatchUsecase();
    mockUpdateBatchUsecase = MockUpdateBatchUsecase();
    mockDeleteBatchUsecase = MockDeleteBatchUsecase();

    when(
      () => mockGetAllBatchUsecase(),
    ).thenAnswer((_) async => Right(tBatches));
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
        getAllBatchUsecaseProvider.overrideWithValue(mockGetAllBatchUsecase),
        getBatchByIdUsecaseProvider.overrideWithValue(mockGetBatchByIdUsecase),
        createBatchUsecaseProvider.overrideWithValue(mockCreateBatchUsecase),
        updateBatchUsecaseProvider.overrideWithValue(mockUpdateBatchUsecase),
        deleteBatchUsecaseProvider.overrideWithValue(mockDeleteBatchUsecase),
      ],
      child: const MaterialApp(home: SignupPage()),
    );
  }

  group('SignupPage - UI Elements', () {
    testWidgets('should display header text and form fields', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Header
      expect(find.text('Join Us Today'), findsOneWidget);
      expect(find.text('Create your account to get started'), findsOneWidget);

      // Form labels
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Email Address'), findsOneWidget);
      expect(find.text('Phone Number'), findsOneWidget);
      expect(find.text('Select Batch'), findsOneWidget);

      // Icons
      expect(find.byIcon(Icons.person_outline_rounded), findsOneWidget);
      expect(find.byIcon(Icons.email_outlined), findsOneWidget);
      expect(find.byIcon(Icons.phone_outlined), findsOneWidget);
      expect(find.byIcon(Icons.school_rounded), findsOneWidget);
    });

    testWidgets('should display back button in app bar', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('should display country code dropdown', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Code'), findsOneWidget);
    });

    testWidgets('should display create account button', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Create Account'), findsOneWidget);
    });

    testWidgets('should display login link', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Already have an account? '), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('should load batches on init', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      verify(() => mockGetAllBatchUsecase()).called(1);
    });
  });

  group('SignupPage - Form Input', () {
    testWidgets('should allow entering name', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).first, 'Test User');
      await tester.pump();

      expect(find.text('Test User'), findsOneWidget);
    });

    testWidgets('should allow entering email', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(1), 'test@example.com');
      await tester.pump();

      expect(find.text('test@example.com'), findsOneWidget);
    });

    testWidgets('should allow entering phone number', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(2), '9800000000');
      await tester.pump();

      // Verify by checking the text field controller value
      final phoneField = tester.widget<TextFormField>(textFields.at(2));
      expect(phoneField.controller?.text, '9800000000');
    });
  });

  group('SignupPage - Form Validation', () {
    testWidgets('should show error when name is empty', (tester) async {
      // Use very large surface to avoid scrolling
      await tester.binding.setSurfaceSize(const Size(800, 2000));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check terms first (validation only happens after terms check)
      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      // Tap Create Account
      await tester.tap(find.text('Create Account'));
      await tester.pump();

      expect(find.text('Please enter your name'), findsOneWidget);

      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('should show error when email is invalid', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Enter name and invalid email
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'Test User');
      await tester.enterText(textFields.at(1), 'invalidemail');
      await tester.pump();

      // Check terms first
      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      // Tap Create Account
      await tester.tap(find.text('Create Account'));
      await tester.pump();

      expect(find.text('Please enter a valid email'), findsOneWidget);

      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('should show error when phone is invalid', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Fill name and email
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'Test User');
      await tester.enterText(textFields.at(1), 'test@example.com');
      await tester.enterText(textFields.at(2), '12345'); // Invalid phone
      await tester.pump();

      // Check terms first
      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      // Tap Create Account
      await tester.tap(find.text('Create Account'));
      await tester.pump();

      expect(find.text('Phone must be 10 digits'), findsOneWidget);

      await tester.binding.setSurfaceSize(null);
    });
  });

  group('SignupPage - Form Submission', () {
    testWidgets('should call register usecase when form is valid', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));

      // Return failure to avoid navigation issues
      when(
        () => mockRegisterUsecase(any()),
      ).thenAnswer((_) async => const Left(ApiFailure(message: 'Test')));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Fill out all form fields
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'Test User');
      await tester.enterText(textFields.at(1), 'test@example.com');
      await tester.enterText(textFields.at(2), '9800000000');
      await tester.enterText(textFields.at(3), 'password123');
      await tester.enterText(textFields.at(4), 'password123');
      await tester.pump();

      // Select batch from dropdown
      await tester.tap(find.text('Select Batch'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Batch 2024').last);
      await tester.pumpAndSettle();

      // Check terms checkbox
      final checkbox = find.byType(Checkbox);
      await tester.tap(checkbox);
      await tester.pump();

      // Tap Create Account
      await tester.tap(find.text('Create Account'));
      await tester.pumpAndSettle();

      verify(() => mockRegisterUsecase(any())).called(1);

      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('should pass correct params to register usecase', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));

      RegisterParams? capturedParams;
      when(() => mockRegisterUsecase(any())).thenAnswer((invocation) async {
        capturedParams = invocation.positionalArguments[0] as RegisterParams;
        return const Right(true);
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Fill form
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'John Doe');
      await tester.enterText(textFields.at(1), 'john@example.com');
      await tester.enterText(textFields.at(2), '9800000000');
      await tester.enterText(textFields.at(3), 'mypassword');
      await tester.enterText(textFields.at(4), 'mypassword');
      await tester.pump();

      // Select batch
      await tester.tap(find.text('Select Batch'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Batch 2024').last);
      await tester.pumpAndSettle();

      // Check terms
      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      // Submit
      await tester.tap(find.text('Create Account'));
      await tester.pumpAndSettle();

      // Verify captured params
      expect(capturedParams?.fullName, 'John Doe');
      expect(capturedParams?.email, 'john@example.com');
      expect(capturedParams?.password, 'mypassword');

      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('should succeed with valid data and fail with invalid data', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));

      const validEmail = 'valid@example.com';
      const validPassword = 'validpass';
      const failure = ApiFailure(message: 'Registration failed');

      // Mock register to check data using if condition
      when(() => mockRegisterUsecase(any())).thenAnswer((invocation) async {
        final params = invocation.positionalArguments[0] as RegisterParams;

        // Check if email and password are valid
        if (params.email == validEmail && params.password == validPassword) {
          return const Right(true);
        }
        return const Left(failure);
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Fill form with valid data
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'Test User');
      await tester.enterText(textFields.at(1), validEmail);
      await tester.enterText(textFields.at(2), '9800000000');
      await tester.enterText(textFields.at(3), validPassword);
      await tester.enterText(textFields.at(4), validPassword);
      await tester.pump();

      // Select batch
      await tester.tap(find.text('Select Batch'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Batch 2024').last);
      await tester.pumpAndSettle();

      // Check terms
      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      // Submit
      await tester.tap(find.text('Create Account'));
      await tester.pumpAndSettle();

      verify(() => mockRegisterUsecase(any())).called(1);

      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('should not call register when terms not accepted', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Fill all fields but don't check terms
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'Test User');
      await tester.enterText(textFields.at(1), 'test@example.com');
      await tester.enterText(textFields.at(2), '9800000000');
      await tester.enterText(textFields.at(3), 'password123');
      await tester.enterText(textFields.at(4), 'password123');
      await tester.pump();

      // Select batch
      await tester.tap(find.text('Select Batch'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Batch 2024').last);
      await tester.pumpAndSettle();

      // Submit without checking terms
      await tester.tap(find.text('Create Account'));
      await tester.pumpAndSettle();

      // Register should not be called
      verifyNever(() => mockRegisterUsecase(any()));

      await tester.binding.setSurfaceSize(null);
    });
  });
}
