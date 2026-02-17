import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lost_n_found/features/auth/presentation/bloc/auth_event.dart';
import 'package:lost_n_found/features/auth/presentation/pages/signup_page.dart';
import 'package:lost_n_found/features/auth/presentation/state/auth_state.dart';
import 'package:lost_n_found/features/auth/presentation/widgets/password_field.dart';
import 'package:lost_n_found/features/batch/domain/entities/batch_entity.dart';
import 'package:lost_n_found/features/batch/presentation/bloc/batch_bloc.dart';
import 'package:lost_n_found/features/batch/presentation/bloc/batch_event.dart';
import 'package:lost_n_found/features/batch/presentation/state/batch_state.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

class MockBatchBloc extends MockBloc<BatchEvent, BatchState>
    implements BatchBloc {}

class FakeAuthEvent extends Fake implements AuthEvent {}

class FakeAuthState extends Fake implements AuthState {}

class FakeBatchEvent extends Fake implements BatchEvent {}

class FakeBatchState extends Fake implements BatchState {}

void main() {
  late MockAuthBloc mockAuthBloc;
  late MockBatchBloc mockBatchBloc;

  const tBatches = [
    BatchEntity(batchId: 'b1', batchName: '35A'),
    BatchEntity(batchId: 'b2', batchName: '35B'),
  ];

  setUpAll(() {
    registerFallbackValue(FakeAuthEvent());
    registerFallbackValue(FakeAuthState());
    registerFallbackValue(FakeBatchEvent());
    registerFallbackValue(FakeBatchState());
  });

  setUp(() {
    mockAuthBloc = MockAuthBloc();
    mockBatchBloc = MockBatchBloc();
    when(() => mockAuthBloc.state).thenReturn(const AuthState());
    when(() => mockBatchBloc.state).thenReturn(const BatchState(
      status: BatchStatus.loaded,
      batches: tBatches,
    ));
  });

  Widget buildWidget() {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>.value(value: mockAuthBloc),
          BlocProvider<BatchBloc>.value(value: mockBatchBloc),
        ],
        child: const SignupPage(),
      ),
    );
  }

  group('SignupPage', () {
    testWidgets('renders signup page with all key elements',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Join Us Today'), findsOneWidget);
      expect(find.text('Create your account to get started'), findsOneWidget);
      expect(find.text('Create Account'), findsOneWidget);
    });

    testWidgets('shows terms error when submitting without agreeing',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Create Account'));
      await tester.tap(find.text('Create Account'));
      await tester.pumpAndSettle();

      // Should show snackbar about terms, not form validation
      expect(
        find.text('Please agree to the Terms & Conditions'),
        findsOneWidget,
      );
    });

    testWidgets('shows form validation errors after agreeing to terms',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      // First agree to terms by tapping the checkbox
      await tester.ensureVisible(find.byType(Checkbox));
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      // Now tap Create Account - form validation should trigger
      await tester.ensureVisible(find.text('Create Account'));
      await tester.tap(find.text('Create Account'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter your name'), findsOneWidget);
    });

    testWidgets('renders password fields',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      // Should have 2 PasswordField widgets
      expect(find.byType(PasswordField), findsNWidgets(2));
    });

    testWidgets('shows batch dropdown with loaded batches',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      final batchDropdown = find.widgetWithText(
          DropdownButtonFormField<String>, 'Select Batch');
      expect(batchDropdown, findsOneWidget);
    });

    testWidgets('shows loading hint when batches are loading',
        (WidgetTester tester) async {
      when(() => mockBatchBloc.state).thenReturn(
          const BatchState(status: BatchStatus.loading));

      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Loading batches...'), findsOneWidget);
    });

    testWidgets('back button navigates back',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MultiBlocProvider(
                    providers: [
                      BlocProvider<AuthBloc>.value(value: mockAuthBloc),
                      BlocProvider<BatchBloc>.value(value: mockBatchBloc),
                    ],
                    child: const SignupPage(),
                  ),
                ),
              ),
              child: const Text('Go to Signup'),
            ),
          ),
        ),
      ));

      await tester.tap(find.text('Go to Signup'));
      await tester.pumpAndSettle();

      expect(find.byType(SignupPage), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      expect(find.byType(SignupPage), findsNothing);
    });
  });
}
