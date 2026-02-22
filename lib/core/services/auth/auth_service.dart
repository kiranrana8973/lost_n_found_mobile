import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/app/routes/app_router.dart';
import 'package:lost_n_found/core/api/api_client.dart';
import 'package:lost_n_found/features/auth/presentation/view_model/auth_viewmodel.dart';

/// Auth service that handles token expiration and logout
class AuthService {
  final Ref _ref;

  AuthService(this._ref) {
    _setupTokenExpirationHandler();
  }

  /// Setup handler for when token expires
  void _setupTokenExpirationHandler() {
    ApiClient.onTokenExpired = () {
      if (kDebugMode) {
        print('🔐 AuthService: Token expired, logging out user');
      }

      // Logout user through auth view model
      _ref.read(authViewModelProvider.notifier).logout();

      // Navigate to login using GoRouter
      final router = _ref.read(routerProvider);
      router.go('/login');

      if (kDebugMode) {
        print('✅ AuthService: User logged out and redirected to login');
      }
    };
  }
}

/// Provider for AuthService
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref);
});

/// Provider to initialize auth service on app startup
final authServiceInitProvider = Provider<void>((ref) {
  // This will initialize the auth service
  ref.watch(authServiceProvider);
});
