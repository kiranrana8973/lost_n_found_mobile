import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/features/auth/domain/entities/auth_entity.dart';
import 'package:lost_n_found/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:lost_n_found/features/auth/domain/usecases/login_usecase.dart';
import 'package:lost_n_found/features/auth/domain/usecases/logout_usecase.dart';
import 'package:lost_n_found/features/auth/domain/usecases/register_usecase.dart';
import 'package:lost_n_found/features/auth/presentation/state/auth_state.dart';
import 'package:lost_n_found/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

class MockRegisterUsecase extends Mock implements RegisterUsecase {}

class MockLoginUsecase extends Mock implements LoginUsecase {}

class MockGetCurrentUserUsecase extends Mock implements GetCurrentUserUsecase {}

class MockLogoutUsecase extends Mock implements LogoutUsecase {}

void main() {
  late MockRegisterUsecase mockRegisterUsecase;
  late MockLoginUsecase mockLoginUsecase;
  late MockGetCurrentUserUsecase mockGetCurrentUserUsecase;
  late MockLogoutUsecase mockLogoutUsecase;
  late ProviderContainer container;

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

    container = ProviderContainer(
      overrides: [
        registerUsecaseProvider.overrideWithValue(mockRegisterUsecase),
        loginUsecaseProvider.overrideWithValue(mockLoginUsecase),
        getCurrentUserUsecaseProvider.overrideWithValue(
          mockGetCurrentUserUsecase,
        ),
        logoutUsecaseProvider.overrideWithValue(mockLogoutUsecase),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  const tUser = AuthEntity(
    authId: '1',
    fullName: 'Test User',
    email: 'test@example.com',
    username: 'testuser',
  );

  group('AuthViewModel', () {
    group('initial state', () {
      test('should have initial state when created', () {
        // Act
        final state = container.read(authViewModelProvider);

        // Assert
        expect(state.status, AuthStatus.initial);
        expect(state.user, isNull);
        expect(state.errorMessage, isNull);
      });
    });

    group('register', () {
      test(
        'should emit registered state when registration is successful',
        () async {
          // Arrange
          when(
            () => mockRegisterUsecase(any()),
          ).thenAnswer((_) async => const Right(true));

          final viewModel = container.read(authViewModelProvider.notifier);

          // Act
          await viewModel.register(
            fullName: 'Test User',
            email: 'test@example.com',
            username: 'testuser',
            password: 'password123',
          );

          // Assert
          final state = container.read(authViewModelProvider);
          expect(state.status, AuthStatus.registered);
          verify(() => mockRegisterUsecase(any())).called(1);
        },
      );

      test('should emit error state when registration fails', () async {
        // Arrange
        const failure = ApiFailure(message: 'Email already exists');
        when(
          () => mockRegisterUsecase(any()),
        ).thenAnswer((_) async => const Left(failure));

        final viewModel = container.read(authViewModelProvider.notifier);

        // Act
        await viewModel.register(
          fullName: 'Test User',
          email: 'test@example.com',
          username: 'testuser',
          password: 'password123',
        );

        // Assert
        final state = container.read(authViewModelProvider);
        expect(state.status, AuthStatus.error);
        expect(state.errorMessage, 'Email already exists');
        verify(() => mockRegisterUsecase(any())).called(1);
      });

      test('should pass optional parameters correctly', () async {
        // Arrange
        RegisterParams? capturedParams;
        when(() => mockRegisterUsecase(any())).thenAnswer((invocation) {
          capturedParams = invocation.positionalArguments[0] as RegisterParams;
          return Future.value(const Right(true));
        });

        final viewModel = container.read(authViewModelProvider.notifier);

        // Act
        await viewModel.register(
          fullName: 'Test User',
          email: 'test@example.com',
          username: 'testuser',
          password: 'password123',
          phoneNumber: '1234567890',
          batchId: 'batch1',
        );

        // Assert
        expect(capturedParams?.phoneNumber, '1234567890');
        expect(capturedParams?.batchId, 'batch1');
      });
    });

    group('login', () {
      test(
        'should emit authenticated state with user when login is successful',
        () async {
          // Arrange
          when(
            () => mockLoginUsecase(any()),
          ).thenAnswer((_) async => const Right(tUser));

          final viewModel = container.read(authViewModelProvider.notifier);

          // Act
          await viewModel.login(
            email: 'test@example.com',
            password: 'password',
          );

          // Assert
          final state = container.read(authViewModelProvider);
          expect(state.status, AuthStatus.authenticated);
          expect(state.user, tUser);
          verify(() => mockLoginUsecase(any())).called(1);
        },
      );

      test('should emit error state when login fails', () async {
        // Arrange
        const failure = ApiFailure(message: 'Invalid credentials');
        when(
          () => mockLoginUsecase(any()),
        ).thenAnswer((_) async => const Left(failure));

        final viewModel = container.read(authViewModelProvider.notifier);

        // Act
        await viewModel.login(email: 'test@example.com', password: 'password');

        // Assert
        final state = container.read(authViewModelProvider);
        expect(state.status, AuthStatus.error);
        expect(state.errorMessage, 'Invalid credentials');
        verify(() => mockLoginUsecase(any())).called(1);
      });

      test('should pass correct credentials to usecase', () async {
        // Arrange
        LoginParams? capturedParams;
        when(() => mockLoginUsecase(any())).thenAnswer((invocation) {
          capturedParams = invocation.positionalArguments[0] as LoginParams;
          return Future.value(const Right(tUser));
        });

        final viewModel = container.read(authViewModelProvider.notifier);

        // Act
        await viewModel.login(
          email: 'test@example.com',
          password: 'password123',
        );

        // Assert
        expect(capturedParams?.email, 'test@example.com');
        expect(capturedParams?.password, 'password123');
      });
    });

    group('getCurrentUser', () {
      test(
        'should emit authenticated state with user when user is found',
        () async {
          // Arrange
          when(
            () => mockGetCurrentUserUsecase(),
          ).thenAnswer((_) async => const Right(tUser));

          final viewModel = container.read(authViewModelProvider.notifier);

          // Act
          await viewModel.getCurrentUser();

          // Assert
          final state = container.read(authViewModelProvider);
          expect(state.status, AuthStatus.authenticated);
          expect(state.user, tUser);
          verify(() => mockGetCurrentUserUsecase()).called(1);
        },
      );

      test(
        'should emit unauthenticated state when user is not found',
        () async {
          // Arrange
          const failure = ApiFailure(message: 'User not found');
          when(
            () => mockGetCurrentUserUsecase(),
          ).thenAnswer((_) async => const Left(failure));

          final viewModel = container.read(authViewModelProvider.notifier);

          // Act
          await viewModel.getCurrentUser();

          // Assert
          final state = container.read(authViewModelProvider);
          expect(state.status, AuthStatus.unauthenticated);
          expect(state.errorMessage, 'User not found');
          verify(() => mockGetCurrentUserUsecase()).called(1);
        },
      );
    });

    group('logout', () {
      test(
        'should emit unauthenticated state with null user when successful',
        () async {
          // Arrange
          when(
            () => mockLogoutUsecase(),
          ).thenAnswer((_) async => const Right(true));

          final viewModel = container.read(authViewModelProvider.notifier);

          // Act
          await viewModel.logout();

          // Assert
          final state = container.read(authViewModelProvider);
          expect(state.status, AuthStatus.unauthenticated);
          verify(() => mockLogoutUsecase()).called(1);
        },
      );

      test('should emit error state when logout fails', () async {
        // Arrange
        const failure = ApiFailure(message: 'Logout failed');
        when(
          () => mockLogoutUsecase(),
        ).thenAnswer((_) async => const Left(failure));

        final viewModel = container.read(authViewModelProvider.notifier);

        // Act
        await viewModel.logout();

        // Assert
        final state = container.read(authViewModelProvider);
        expect(state.status, AuthStatus.error);
        expect(state.errorMessage, 'Logout failed');
        verify(() => mockLogoutUsecase()).called(1);
      });
    });

    group('clearError', () {
      test('should call clearError without throwing', () async {
        // Arrange
        const failure = ApiFailure(message: 'Some error');
        when(
          () => mockLoginUsecase(any()),
        ).thenAnswer((_) async => const Left(failure));

        final viewModel = container.read(authViewModelProvider.notifier);
        await viewModel.login(email: 'test@example.com', password: 'password');

        // Verify error is set
        final state = container.read(authViewModelProvider);
        expect(state.errorMessage, 'Some error');

        // Act & Assert - should not throw
        expect(() => viewModel.clearError(), returnsNormally);
      });
    });
  });

  group('AuthState', () {
    test('should have correct initial values', () {
      // Arrange
      const state = AuthState();

      // Assert
      expect(state.status, AuthStatus.initial);
      expect(state.user, isNull);
      expect(state.errorMessage, isNull);
    });

    test('copyWith should update specified fields', () {
      // Arrange
      const state = AuthState();

      // Act
      final newState = state.copyWith(
        status: AuthStatus.authenticated,
        user: tUser,
      );

      // Assert
      expect(newState.status, AuthStatus.authenticated);
      expect(newState.user, tUser);
      expect(newState.errorMessage, isNull);
    });

    test('copyWith should preserve existing values when not specified', () {
      // Arrange
      const state = AuthState(
        status: AuthStatus.authenticated,
        user: tUser,
        errorMessage: 'error',
      );

      // Act
      final newState = state.copyWith(status: AuthStatus.loading);

      // Assert
      expect(newState.status, AuthStatus.loading);
      expect(newState.user, tUser);
      expect(newState.errorMessage, 'error');
    });

    test('props should contain all fields', () {
      // Arrange
      const state = AuthState(
        status: AuthStatus.authenticated,
        user: tUser,
        errorMessage: 'error',
      );

      // Assert
      expect(state.props, [AuthStatus.authenticated, tUser, 'error']);
    });

    test('two states with same values should be equal', () {
      // Arrange
      const state1 = AuthState(status: AuthStatus.authenticated, user: tUser);
      const state2 = AuthState(status: AuthStatus.authenticated, user: tUser);

      // Assert
      expect(state1, state2);
    });
  });
}
