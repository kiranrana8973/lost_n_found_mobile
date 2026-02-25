import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lost_n_found/app/routes/route_constants.dart';
import 'package:lost_n_found/app/routes/router_notifier.dart';
import 'package:lost_n_found/features/auth/presentation/pages/login_page.dart';
import 'package:lost_n_found/features/auth/presentation/pages/signup_page.dart';
import 'package:lost_n_found/features/auth/presentation/state/auth_state.dart';
import 'package:lost_n_found/features/batch/presentation/pages/batch_page.dart';
import 'package:lost_n_found/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:lost_n_found/features/item/presentation/pages/item_detail_page.dart';
import 'package:lost_n_found/features/item/presentation/pages/report_item_page.dart';
import 'package:lost_n_found/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:lost_n_found/features/splash/presentation/pages/splash_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final routerNotifier = ref.watch(routerNotifierProvider);

  return GoRouter(
    debugLogDiagnostics: kDebugMode,
    initialLocation: RouteConstants.splash,
    refreshListenable: routerNotifier,

    redirect: (context, state) {
      final currentPath = state.uri.path;

      if (kDebugMode) {
        print(
          '🔀 Router: path=$currentPath, '
          'isReady=${routerNotifier.isReady}, '
          'isAuth=${routerNotifier.isAuthenticated}, '
          'status=${routerNotifier.authStatus}',
        );
      }

      if (!routerNotifier.isReady) {
        return currentPath == RouteConstants.splash
            ? null
            : RouteConstants.splash;
      }

      final isAuthenticated = routerNotifier.isAuthenticated;
      final authStatus = routerNotifier.authStatus;

      const publicRoutes = [
        RouteConstants.splash,
        RouteConstants.onboarding,
        RouteConstants.login,
        RouteConstants.signup,
      ];
      final isPublicRoute = publicRoutes.contains(currentPath);

      if (isAuthenticated) {
        if (currentPath == RouteConstants.splash ||
            currentPath == RouteConstants.onboarding ||
            currentPath == RouteConstants.login ||
            currentPath == RouteConstants.signup) {
          return RouteConstants.dashboard;
        }
        return null;
      }

      if (authStatus == AuthStatus.registered &&
          currentPath != RouteConstants.login) {
        return RouteConstants.login;
      }

      if (currentPath == RouteConstants.splash) {
        return routerNotifier.hasCompletedOnboarding
            ? RouteConstants.login
            : RouteConstants.onboarding;
      }

      if (isPublicRoute) return null;

      return RouteConstants.login;
    },

    routes: [
      GoRoute(
        path: RouteConstants.splash,
        name: RouteNames.splash,
        pageBuilder: (context, state) => _buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: const SplashPage(),
        ),
      ),

      GoRoute(
        path: RouteConstants.onboarding,
        name: RouteNames.onboarding,
        pageBuilder: (context, state) => _buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: const OnboardingPage(),
        ),
      ),

      GoRoute(
        path: RouteConstants.login,
        name: RouteNames.login,
        pageBuilder: (context, state) => _buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: const LoginPage(),
        ),
      ),

      GoRoute(
        path: RouteConstants.signup,
        name: RouteNames.signup,
        pageBuilder: (context, state) => _buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: const SignupPage(),
        ),
      ),

      GoRoute(
        path: RouteConstants.dashboard,
        name: RouteNames.dashboard,
        pageBuilder: (context, state) => _buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: const DashboardPage(),
        ),
      ),

      GoRoute(
        path: RouteConstants.reportItem,
        name: RouteNames.reportItem,
        pageBuilder: (context, state) => _buildPageWithSlideTransition(
          context: context,
          state: state,
          child: const ReportItemPage(),
        ),
      ),

      GoRoute(
        path: RouteConstants.itemDetail,
        name: RouteNames.itemDetail,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;

          return _buildPageWithSlideTransition(
            context: context,
            state: state,
            child: ItemDetailPage(
              title: extra?['title'] ?? 'Item Details',
              location: extra?['location'] ?? 'Unknown',
              category: extra?['category'] ?? 'Other',
              isLost: extra?['isLost'] ?? true,
              description: extra?['description'],
              reportedBy: extra?['reportedBy'] ?? 'Unknown',
              imageUrl: extra?['imageUrl'],
              videoUrl: extra?['videoUrl'],
            ),
          );
        },
      ),

      GoRoute(
        path: RouteConstants.batches,
        name: RouteNames.batches,
        pageBuilder: (context, state) => _buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: const BatchPage(),
        ),
      ),
    ],

    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found: ${state.uri.path}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(RouteConstants.dashboard),
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    ),
  );
});

Page _buildPageWithDefaultTransition({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}

Page _buildPageWithSlideTransition({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );
}
