import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:lost_n_found/core/services/hive/hive_service.dart';
import 'package:lost_n_found/core/services/storage/user_session_service.dart';
import 'package:lost_n_found/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Dashboard Integration Tests', () {
    late SharedPreferences sharedPreferences;

    setUpAll(() async {
      await HiveService().init();
      SharedPreferences.setMockInitialValues({});
      sharedPreferences = await SharedPreferences.getInstance();
    });

    Widget createDashboardPage() {
      return ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        ],
        child: const MaterialApp(home: DashboardPage()),
      );
    }

    testWidgets('Dashboard should display bottom navigation bar', (
      tester,
    ) async {
      await tester.pumpWidget(createDashboardPage());
      await tester.pumpAndSettle();

      // Bottom navigation items
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('My Items'), findsOneWidget);
      expect(find.text('Alerts'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('Dashboard should display floating action button', (
      tester,
    ) async {
      await tester.pumpWidget(createDashboardPage());
      await tester.pumpAndSettle();

      // FAB for reporting items
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add_rounded), findsOneWidget);
    });

    testWidgets('Dashboard should show home screen by default', (tester) async {
      await tester.pumpWidget(createDashboardPage());
      await tester.pumpAndSettle();

      // Home icon should be selected (part of gradient)
      expect(find.byIcon(Icons.home_rounded), findsOneWidget);
    });

    testWidgets('Dashboard should navigate to My Items on tap', (tester) async {
      await tester.pumpWidget(createDashboardPage());
      await tester.pumpAndSettle();

      // Tap My Items
      await tester.tap(find.text('My Items'));
      await tester.pumpAndSettle();

      // My Items icon should now be selected
      expect(find.byIcon(Icons.inventory_2_rounded), findsOneWidget);
    });

    testWidgets('Dashboard should navigate to Profile on tap', (tester) async {
      await tester.pumpWidget(createDashboardPage());
      await tester.pumpAndSettle();

      // Tap Profile
      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();

      // Profile icon should now be selected
      expect(find.byIcon(Icons.person_rounded), findsOneWidget);
    });

    testWidgets('Dashboard should show notification badge', (tester) async {
      await tester.pumpWidget(createDashboardPage());
      await tester.pumpAndSettle();

      // Alerts should have badge
      expect(find.byIcon(Icons.notifications_rounded), findsOneWidget);
      expect(find.text('3'), findsOneWidget); // Badge count
    });

    testWidgets('Dashboard FAB should be tappable', (tester) async {
      await tester.pumpWidget(createDashboardPage());
      await tester.pumpAndSettle();

      // Find and tap FAB
      final fab = find.byType(FloatingActionButton);
      expect(fab, findsOneWidget);

      // Tap should not throw error
      await tester.tap(fab);
      await tester.pumpAndSettle();
    });

    testWidgets('Dashboard should switch between screens correctly', (
      tester,
    ) async {
      await tester.pumpWidget(createDashboardPage());
      await tester.pumpAndSettle();

      // Start on Home
      expect(find.byIcon(Icons.home_rounded), findsOneWidget);

      // Go to My Items
      await tester.tap(find.text('My Items'));
      await tester.pumpAndSettle();

      // Go to Profile
      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();

      // Go back to Home
      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();

      // Should be back on home
      expect(find.byIcon(Icons.home_rounded), findsOneWidget);
    });
  });
}
