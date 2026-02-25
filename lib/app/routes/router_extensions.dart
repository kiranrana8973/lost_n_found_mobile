import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lost_n_found/app/routes/route_constants.dart';

extension RouterExtensions on BuildContext {
  void goToSplash() => go(RouteConstants.splash);

  void goToOnboarding() => go(RouteConstants.onboarding);

  void goToLogin() => go(RouteConstants.login);

  void goToSignup() => go(RouteConstants.signup);

  void goToDashboard() => go(RouteConstants.dashboard);

  void goToReportItem() => push(RouteConstants.reportItem);

  void goToBatches() => push(RouteConstants.batches);

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

  bool get isOnLoginPage {
    final location = GoRouterState.of(this).uri.path;
    return location == RouteConstants.login;
  }

  bool get isOnDashboard {
    final location = GoRouterState.of(this).uri.path;
    return location == RouteConstants.dashboard;
  }

  String get currentRoute => GoRouterState.of(this).uri.path;

  void popOrDashboard() {
    if (canPop()) {
      pop();
    } else {
      goToDashboard();
    }
  }

  void clearAndGoToLogin() => go(RouteConstants.login);

  void clearAndGoToDashboard() => go(RouteConstants.dashboard);
}
