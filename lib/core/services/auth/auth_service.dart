import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/app/routes/app_router.dart';
import 'package:lost_n_found/core/api/api_client.dart';
import 'package:lost_n_found/features/auth/presentation/view_model/auth_viewmodel.dart';

class AuthService {
  final Ref _ref;

  AuthService(this._ref) {
    _setupTokenExpirationHandler();
  }

  void _setupTokenExpirationHandler() {
    ApiClient.onTokenExpired = () {
      if (kDebugMode) {
        print('🔐 AuthService: Token expired, logging out user');
      }

      _ref.read(authViewModelProvider.notifier).logout();

      final router = _ref.read(routerProvider);
      router.go('/login');

      if (kDebugMode) {
        print('✅ AuthService: User logged out and redirected to login');
      }
    };
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref);
});

final authServiceInitProvider = Provider<void>((ref) {
  ref.watch(authServiceProvider);
});
