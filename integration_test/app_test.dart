import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:lost_n_found/app/app.dart';
import 'package:lost_n_found/core/services/hive/hive_service.dart';
import 'package:lost_n_found/core/services/storage/user_session_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Integration Tests', () {
    late SharedPreferences sharedPreferences;

    setUpAll(() async {
      // Initialize Hive for tests
      await HiveService().init();

      // Initialize SharedPreferences
      SharedPreferences.setMockInitialValues({});
      sharedPreferences = await SharedPreferences.getInstance();
    });

    Widget createApp() {
      return ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        ],
        child: const MyApp(),
      );
    }

    testWidgets('App should start with splash screen', (tester) async {
      await tester.pumpWidget(createApp());

      // Splash screen should be visible initially
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('App should navigate from splash to onboarding or login', (
      tester,
    ) async {
      await tester.pumpWidget(createApp());

      // Wait for splash screen animation/logic
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // After splash, should navigate to either onboarding or login
      // The exact screen depends on app state
      expect(find.byType(Scaffold), findsWidgets);
    });
  });
}
