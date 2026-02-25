import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/features/auth/domain/entities/auth_entity.dart';
import 'package:lost_n_found/features/auth/presentation/state/auth_state.dart';

void main() {
  const tUser = AuthEntity(
    authId: 'auth-123',
    fullName: 'John Doe',
    email: 'john@example.com',
    username: 'johndoe',
  );

  group('AuthState', () {
    test('should have correct default values', () {
      const state = AuthState();

      expect(state.status, AuthStatus.initial);
      expect(state.user, isNull);
      expect(state.errorMessage, isNull);
    });

    test('should create with provided values', () {
      const state = AuthState(
        status: AuthStatus.authenticated,
        user: tUser,
        errorMessage: 'Some error',
      );

      expect(state.status, AuthStatus.authenticated);
      expect(state.user, tUser);
      expect(state.errorMessage, 'Some error');
    });

    group('copyWith', () {
      test('should preserve unchanged fields when no arguments are passed', () {
        const original = AuthState(
          status: AuthStatus.authenticated,
          user: tUser,
          errorMessage: 'error',
        );

        final copied = original.copyWith();

        expect(copied.status, AuthStatus.authenticated);
        expect(copied.user, tUser);
        expect(copied.errorMessage, 'error');
      });

      test('should update only status', () {
        const original = AuthState(status: AuthStatus.initial, user: tUser);

        final copied = original.copyWith(status: AuthStatus.loading);

        expect(copied.status, AuthStatus.loading);
        expect(copied.user, tUser);
        expect(copied.errorMessage, isNull);
      });

      test('should update only user', () {
        const newUser = AuthEntity(
          authId: 'auth-456',
          fullName: 'Jane Doe',
          email: 'jane@example.com',
          username: 'janedoe',
        );

        const original = AuthState(
          status: AuthStatus.authenticated,
          user: tUser,
        );

        final copied = original.copyWith(user: newUser);

        expect(copied.status, AuthStatus.authenticated);
        expect(copied.user, newUser);
      });

      test('should update only errorMessage', () {
        const original = AuthState(status: AuthStatus.error);

        final copied = original.copyWith(errorMessage: 'Login failed');

        expect(copied.status, AuthStatus.error);
        expect(copied.errorMessage, 'Login failed');
        expect(copied.user, isNull);
      });

      test('should update all fields', () {
        const original = AuthState();

        final copied = original.copyWith(
          status: AuthStatus.error,
          user: tUser,
          errorMessage: 'Something went wrong',
        );

        expect(copied.status, AuthStatus.error);
        expect(copied.user, tUser);
        expect(copied.errorMessage, 'Something went wrong');
      });
    });

    group('equality', () {
      test('should be equal when all properties are the same', () {
        const state1 = AuthState(status: AuthStatus.authenticated, user: tUser);
        const state2 = AuthState(status: AuthStatus.authenticated, user: tUser);

        expect(state1, equals(state2));
      });

      test('should not be equal when status differs', () {
        const state1 = AuthState(status: AuthStatus.initial);
        const state2 = AuthState(status: AuthStatus.loading);

        expect(state1, isNot(equals(state2)));
      });

      test('should not be equal when user differs', () {
        const state1 = AuthState(user: tUser);
        const state2 = AuthState();

        expect(state1, isNot(equals(state2)));
      });

      test('should not be equal when errorMessage differs', () {
        const state1 = AuthState(errorMessage: 'error1');
        const state2 = AuthState(errorMessage: 'error2');

        expect(state1, isNot(equals(state2)));
      });

      test('should have correct props list', () {
        const state = AuthState(
          status: AuthStatus.authenticated,
          user: tUser,
          errorMessage: 'test',
        );

        expect(state.props, [AuthStatus.authenticated, tUser, 'test']);
      });
    });
  });
}
