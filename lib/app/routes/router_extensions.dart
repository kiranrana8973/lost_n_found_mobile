import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lost_n_found/app/routes/route_constants.dart';

/// Extension methods on BuildContext for easy navigation
/// These methods make navigation cleaner and more type-safe
extension RouterExtensions on BuildContext {
  // ============ Navigation Methods ============

  /// Navigate to splash screen
  void goToSplash() => go(RouteConstants.splash);

  /// Navigate to onboarding
  void goToOnboarding() => go(RouteConstants.onboarding);

  /// Navigate to login
  void goToLogin() => go(RouteConstants.login);

  /// Navigate to signup
  void goToSignup() => go(RouteConstants.signup);

  /// Navigate to dashboard
  void goToDashboard() => go(RouteConstants.dashboard);

  /// Navigate to report item page
  void goToReportItem() => push(RouteConstants.reportItem);

  /// Navigate to batches
  void goToBatches() => push(RouteConstants.batches);

  /// Navigate to item detail with all required data
  void goToItemDetail({
    required String id,
    required String title,
    required String location,
    required String category,
    required bool isLost,
    String? description,
    required String reportedBy,
    String? imageUrl,
    String? videoUrl,
  }) {
    push(
      RouteConstants.itemDetailWithId(id),
      extra: {
        'title': title,
        'location': location,
        'category': category,
        'isLost': isLost,
        'description': description,
        'reportedBy': reportedBy,
        'imageUrl': imageUrl,
        'videoUrl': videoUrl,
      },
    );
  }

  // ============ Helper Methods ============

  /// Check if currently on login page
  bool get isOnLoginPage {
    final location = GoRouterState.of(this).uri.path;
    return location == RouteConstants.login;
  }

  /// Check if currently on dashboard
  bool get isOnDashboard {
    final location = GoRouterState.of(this).uri.path;
    return location == RouteConstants.dashboard;
  }

  /// Get current route path
  String get currentRoute => GoRouterState.of(this).uri.path;

  /// Navigate back if possible, otherwise go to dashboard
  void popOrDashboard() {
    if (canPop()) {
      pop();
    } else {
      goToDashboard();
    }
  }

  /// Clear navigation stack and go to login
  void clearAndGoToLogin() => go(RouteConstants.login);

  /// Clear navigation stack and go to dashboard
  void clearAndGoToDashboard() => go(RouteConstants.dashboard);
}
