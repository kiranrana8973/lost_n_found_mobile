import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
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

  group('SignupPage', () {
    testWidgets('should display header text', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Join Us Today'), findsOneWidget);
      expect(find.text('Create your account to get started'), findsOneWidget);
    });

    testWidgets('should display name field', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Full Name'), findsOneWidget);
    });

    testWidgets('should display email field', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Email Address'), findsOneWidget);
    });

    testWidgets('should display phone field', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Phone Number'), findsOneWidget);
    });

    testWidgets('should display batch dropdown', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Select Batch'), findsOneWidget);
    });

    testWidgets('should display form fields', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(TextFormField), findsAtLeast(3));
    });

    testWidgets('should have back button in app bar', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('should show person icon for name field', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.person_outline_rounded), findsOneWidget);
    });

    testWidgets('should show email icon', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.email_outlined), findsOneWidget);
    });

    testWidgets('should show phone icon', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.phone_outlined), findsOneWidget);
    });

    testWidgets('should show school icon for batch dropdown', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.school_rounded), findsOneWidget);
    });

    testWidgets('should load batches on init', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      verify(() => mockGetAllBatchUsecase()).called(1);
    });

    testWidgets('should display country code dropdown', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Code'), findsOneWidget);
    });

    testWidgets('should allow entering text in name field', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).first, 'Test User');
      await tester.pump();

      expect(find.text('Test User'), findsOneWidget);
    });

    testWidgets('should allow entering text in email field', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(1), 'test@example.com');
      await tester.pump();

      expect(find.text('test@example.com'), findsOneWidget);
    });

    testWidgets(
      'should call register usecase when form is valid and submitted',
      (tester) async {
        // Set a larger surface size to avoid scrolling issues
        await tester.binding.setSurfaceSize(const Size(800, 1200));

        // Mock register to return success
        when(
          () => mockRegisterUsecase(any()),
        ).thenAnswer((_) async => const Right(true));

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Fill out all form fields
        final textFields = find.byType(TextFormField);

        // Name field
        await tester.enterText(textFields.at(0), 'Test User');
        // Email field
        await tester.enterText(textFields.at(1), 'test@example.com');
        // Phone field
        await tester.enterText(textFields.at(2), '9800000000');
        // Password field
        await tester.enterText(textFields.at(3), 'password123');
        // Confirm Password field
        await tester.enterText(textFields.at(4), 'password123');

        await tester.pump();

        // Select a batch from dropdown
        await tester.tap(find.text('Select Batch').last);
        await tester.pumpAndSettle();
        await tester.tap(find.text('Batch 2024').last);
        await tester.pumpAndSettle();

        // Check the terms checkbox
        final checkbox = find.byType(Checkbox);
        await tester.tap(checkbox);
        await tester.pump();

        // Tap Create Account button
        await tester.tap(find.text('Create Account'));
        await tester.pumpAndSettle();

        // Verify register usecase was called
        verify(() => mockRegisterUsecase(any())).called(1);

        // Reset surface size
        await tester.binding.setSurfaceSize(null);
      },
    );
  });
}
