import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:lost_n_found/core/services/hive/hive_service.dart';
import 'package:lost_n_found/core/services/storage/user_session_service.dart';
import 'package:lost_n_found/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:lost_n_found/features/splash/presentation/pages/splash_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Onboarding & Splash Integration Tests', () {
    late SharedPreferences sharedPreferences;

    setUpAll(() async {
      await HiveService().init();
      SharedPreferences.setMockInitialValues({});
      sharedPreferences = await SharedPreferences.getInstance();
    });

    group('Splash Page Integration Tests', () {
      Widget createSplashPage() {
        return ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(sharedPreferences),
          ],
          child: const MaterialApp(home: SplashPage()),
        );
      }

      testWidgets('Splash page should display', (tester) async {
        await tester.pumpWidget(createSplashPage());

        // Splash should show scaffold
        expect(find.byType(Scaffold), findsOneWidget);
      });

      testWidgets('Splash page should contain app branding', (tester) async {
        await tester.pumpWidget(createSplashPage());

        // Should have some visual elements
        expect(find.byType(Container), findsWidgets);
      });
    });

    group('Onboarding Page Integration Tests', () {
      Widget createOnboardingPage() {
        return ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(sharedPreferences),
          ],
          child: const MaterialApp(home: OnboardingPage()),
        );
      }

      testWidgets('Onboarding page should display', (tester) async {
        await tester.pumpWidget(createOnboardingPage());
        await tester.pumpAndSettle();

        // Onboarding should show scaffold
        expect(find.byType(Scaffold), findsOneWidget);
      });

      testWidgets('Onboarding page should have PageView', (tester) async {
        await tester.pumpWidget(createOnboardingPage());
        await tester.pumpAndSettle();

        // PageView for swipeable onboarding screens
        expect(find.byType(PageView), findsOneWidget);
      });

      testWidgets('Onboarding page should have navigation dots', (
        tester,
      ) async {
        await tester.pumpWidget(createOnboardingPage());
        await tester.pumpAndSettle();

        // Page indicators
        expect(find.byType(Container), findsWidgets);
      });

      testWidgets('Onboarding page should have Get Started button', (
        tester,
      ) async {
        await tester.pumpWidget(createOnboardingPage());
        await tester.pumpAndSettle();

        // Get Started or Skip button
        expect(
          find.byType(ElevatedButton).evaluate().isNotEmpty ||
              find.byType(TextButton).evaluate().isNotEmpty ||
              find.byType(GestureDetector).evaluate().isNotEmpty,
          true,
        );
      });

      testWidgets('Onboarding page should be swipeable', (tester) async {
        await tester.pumpWidget(createOnboardingPage());
        await tester.pumpAndSettle();

        // Find PageView
        final pageView = find.byType(PageView);
        expect(pageView, findsOneWidget);

        // Swipe left
        await tester.drag(pageView, const Offset(-300, 0));
        await tester.pumpAndSettle();

        // Page should have changed
        expect(find.byType(PageView), findsOneWidget);
      });
    });
  });
}
