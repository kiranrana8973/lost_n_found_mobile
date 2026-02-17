import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/features/auth/domain/entities/auth_entity.dart';
import 'package:lost_n_found/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:lost_n_found/features/auth/domain/usecases/login_usecase.dart';
import 'package:lost_n_found/features/auth/domain/usecases/logout_usecase.dart';
import 'package:lost_n_found/features/auth/domain/usecases/register_usecase.dart';
import 'package:lost_n_found/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lost_n_found/features/auth/presentation/bloc/auth_event.dart';
import 'package:lost_n_found/features/auth/presentation/state/auth_state.dart';
import 'package:mocktail/mocktail.dart';

// Mocks
class MockRegisterUsecase extends Mock implements RegisterUsecase {}

class MockLoginUsecase extends Mock implements LoginUsecase {}

class MockGetCurrentUserUsecase extends Mock implements GetCurrentUserUsecase {}

class MockLogoutUsecase extends Mock implements LogoutUsecase {}

void main() {
  late AuthBloc authBloc;
  late MockRegisterUsecase mockRegisterUsecase;
  late MockLoginUsecase mockLoginUsecase;
  late MockGetCurrentUserUsecase mockGetCurrentUserUsecase;
  late MockLogoutUsecase mockLogoutUsecase;

  const tUser = AuthEntity(
    authId: 'user-1',
    fullName: 'Test User',
    email: 'test@test.com',
    username: 'testuser',
  );

  setUpAll(() {
    registerFallbackValue(
      const RegisterParams(fullName: '', email: '', username: '', password: ''),
    );
    registerFallbackValue(const LoginParams(email: '', password: ''));
  });

  setUp(() {
    mockRegisterUsecase = MockRegisterUsecase();
    mockLoginUsecase = MockLoginUsecase();
    mockGetCurrentUserUsecase = MockGetCurrentUserUsecase();
    mockLogoutUsecase = MockLogoutUsecase();

    authBloc = AuthBloc(
      registerUsecase: mockRegisterUsecase,
      loginUsecase: mockLoginUsecase,
      getCurrentUserUsecase: mockGetCurrentUserUsecase,
      logoutUsecase: mockLogoutUsecase,
    );
  });

  tearDown(() {
    authBloc.close();
  });

  test('initial state is AuthState with initial status', () {
    expect(authBloc.state, const AuthState());
    expect(authBloc.state.status, AuthStatus.initial);
  });

  group('AuthRegisterEvent', () {
    const tEvent = AuthRegisterEvent(
      fullName: 'Test User',
      email: 'test@test.com',
      username: 'testuser',
      password: 'password123',
      batchId: 'batch-1',
    );

    blocTest<AuthBloc, AuthState>(
      'emits [loading, registered] when registration succeeds',
      build: () {
        when(
          () => mockRegisterUsecase(any()),
        ).thenAnswer((_) async => const Right(true));
        return authBloc;
      },
      act: (bloc) => bloc.add(tEvent),
      expect: () => [
        const AuthState(status: AuthStatus.loading),
        const AuthState(status: AuthStatus.registered),
      ],
      verify: (_) {
        verify(() => mockRegisterUsecase(any())).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits [loading, error] when registration fails',
      build: () {
        when(() => mockRegisterUsecase(any())).thenAnswer(
          (_) async => const Left(ApiFailure(message: 'Email already exists')),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(tEvent),
      expect: () => [
        const AuthState(status: AuthStatus.loading),
        const AuthState(
          status: AuthStatus.error,
          errorMessage: 'Email already exists',
        ),
      ],
    );
  });

  group('AuthLoginEvent', () {
    const tEvent = AuthLoginEvent(
      email: 'test@test.com',
      password: 'password123',
    );

    blocTest<AuthBloc, AuthState>(
      'emits [loading, authenticated] with user when login succeeds',
      build: () {
        when(
          () => mockLoginUsecase(any()),
        ).thenAnswer((_) async => const Right(tUser));
        return authBloc;
      },
      act: (bloc) => bloc.add(tEvent),
      expect: () => [
        const AuthState(status: AuthStatus.loading),
        const AuthState(status: AuthStatus.authenticated, user: tUser),
      ],
      verify: (_) {
        verify(() => mockLoginUsecase(any())).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits [loading, error] when login fails',
      build: () {
        when(() => mockLoginUsecase(any())).thenAnswer(
          (_) async => const Left(ApiFailure(message: 'Invalid credentials')),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(tEvent),
      expect: () => [
        const AuthState(status: AuthStatus.loading),
        const AuthState(
          status: AuthStatus.error,
          errorMessage: 'Invalid credentials',
        ),
      ],
    );
  });

  group('AuthGetCurrentUserEvent', () {
    blocTest<AuthBloc, AuthState>(
      'emits [loading, authenticated] when get current user succeeds',
      build: () {
        when(
          () => mockGetCurrentUserUsecase(),
        ).thenAnswer((_) async => const Right(tUser));
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthGetCurrentUserEvent()),
      expect: () => [
        const AuthState(status: AuthStatus.loading),
        const AuthState(status: AuthStatus.authenticated, user: tUser),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [loading, unauthenticated] when get current user fails',
      build: () {
        when(() => mockGetCurrentUserUsecase()).thenAnswer(
          (_) async => const Left(ApiFailure(message: 'Not logged in')),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthGetCurrentUserEvent()),
      expect: () => [
        const AuthState(status: AuthStatus.loading),
        const AuthState(
          status: AuthStatus.unauthenticated,
          errorMessage: 'Not logged in',
        ),
      ],
    );
  });

  group('AuthLogoutEvent', () {
    blocTest<AuthBloc, AuthState>(
      'emits [loading, unauthenticated] when logout succeeds',
      build: () {
        when(
          () => mockLogoutUsecase(),
        ).thenAnswer((_) async => const Right(true));
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthLogoutEvent()),
      expect: () => [
        const AuthState(status: AuthStatus.loading),
        const AuthState(status: AuthStatus.unauthenticated),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [loading, error] when logout fails',
      build: () {
        when(() => mockLogoutUsecase()).thenAnswer(
          (_) async => const Left(ApiFailure(message: 'Logout failed')),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthLogoutEvent()),
      expect: () => [
        const AuthState(status: AuthStatus.loading),
        const AuthState(
          status: AuthStatus.error,
          errorMessage: 'Logout failed',
        ),
      ],
    );
  });

  group('AuthClearErrorEvent', () {
    blocTest<AuthBloc, AuthState>(
      'clears error message from state',
      build: () => authBloc,
      seed: () =>
          const AuthState(status: AuthStatus.error, errorMessage: 'Some error'),
      act: (bloc) => bloc.add(const AuthClearErrorEvent()),
      expect: () => [const AuthState(status: AuthStatus.error)],
    );
  });
}
