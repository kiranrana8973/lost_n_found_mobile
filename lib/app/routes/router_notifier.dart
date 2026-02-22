import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/core/services/storage/user_session_service.dart';
import 'package:lost_n_found/features/auth/presentation/state/auth_state.dart';
import 'package:lost_n_found/features/auth/presentation/view_model/auth_viewmodel.dart';

/// Notifier that listens to authentication state changes
/// and notifies GoRouter to rebuild when auth state changes.
///
/// This is the SINGLE source of truth for navigation decisions.
/// The splash page should NOT navigate — the router redirect handles everything.
class RouterNotifier extends ChangeNotifier {
  final Ref _ref;
  bool _splashTimerComplete = false;

  RouterNotifier(this._ref) {
    // Minimum splash display time (for branding/animation)
    Future.delayed(const Duration(seconds: 2), () {
      _splashTimerComplete = true;
      notifyListeners();
    });

    // Listen to auth state changes and notify GoRouter
    _ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      if (previous?.status != next.status) {
        if (kDebugMode) {
          print(
            '🔄 Router: Auth state changed from ${previous?.status} to ${next.status}',
          );
        }
        notifyListeners();
      }
    });
  }

  /// Whether the app is ready to leave the splash screen.
  /// True when: splash timer is done AND auth state has been resolved.
  bool get isReady {
    final status = authStatus;
    final authResolved =
        status != AuthStatus.initial && status != AuthStatus.loading;
    return _splashTimerComplete && authResolved;
  }

  /// Check if user is authenticated
  bool get isAuthenticated {
    final authState = _ref.read(authViewModelProvider);
    return authState.status == AuthStatus.authenticated &&
        authState.user != null;
  }

  /// Get current auth status
  AuthStatus get authStatus {
    return _ref.read(authViewModelProvider).status;
  }

  /// Check if user has completed onboarding (persists across logout)
  bool get hasCompletedOnboarding {
    return _ref.read(userSessionServiceProvider).hasSeenOnboarding();
  }
}

/// Provider for RouterNotifier
final routerNotifierProvider = Provider<RouterNotifier>((ref) {
  return RouterNotifier(ref);
});
