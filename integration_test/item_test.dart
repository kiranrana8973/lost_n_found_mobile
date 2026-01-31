import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:lost_n_found/core/services/hive/hive_service.dart';
import 'package:lost_n_found/core/services/storage/user_session_service.dart';
import 'package:lost_n_found/features/item/presentation/pages/report_item_page.dart';
import 'package:lost_n_found/features/item/presentation/pages/my_items_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Item Integration Tests', () {
    late SharedPreferences sharedPreferences;

    setUpAll(() async {
      await HiveService().init();
      SharedPreferences.setMockInitialValues({});
      sharedPreferences = await SharedPreferences.getInstance();
    });

    group('Report Item Page Integration Tests', () {
      Widget createReportItemPage() {
        return ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(sharedPreferences),
          ],
          child: const MaterialApp(home: ReportItemPage()),
        );
      }

      testWidgets('Report Item page should display header', (tester) async {
        await tester.pumpWidget(createReportItemPage());
        await tester.pumpAndSettle();

        // Header
        expect(find.text('Report Item'), findsOneWidget);
        expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
      });

      testWidgets('Report Item page should display item type toggle', (
        tester,
      ) async {
        await tester.pumpWidget(createReportItemPage());
        await tester.pumpAndSettle();

        // Item type toggle (Lost/Found)
        expect(find.text('Lost'), findsOneWidget);
        expect(find.text('Found'), findsOneWidget);
      });

      testWidgets('Report Item page should display form fields', (
        tester,
      ) async {
        await tester.pumpWidget(createReportItemPage());
        await tester.pumpAndSettle();

        // Form section headers
        expect(find.text('Item Name'), findsOneWidget);
        expect(find.text('Category'), findsOneWidget);
        expect(find.text('Location'), findsOneWidget);
        expect(find.text('Description'), findsOneWidget);
      });

      testWidgets('Report Item page should allow item name entry', (
        tester,
      ) async {
        await tester.pumpWidget(createReportItemPage());
        await tester.pumpAndSettle();

        // Find text field by hint
        final textFields = find.byType(TextFormField);
        expect(textFields, findsWidgets);

        // Enter item name
        await tester.enterText(textFields.first, 'iPhone 14 Pro');
        await tester.pump();

        expect(find.text('iPhone 14 Pro'), findsOneWidget);
      });

      testWidgets('Report Item page should toggle between Lost and Found', (
        tester,
      ) async {
        await tester.pumpWidget(createReportItemPage());
        await tester.pumpAndSettle();

        // Initially Lost is selected
        expect(find.text('Lost'), findsOneWidget);

        // Tap Found
        await tester.tap(find.text('Found'));
        await tester.pumpAndSettle();

        // Found should now be selected
        expect(find.text('Found'), findsOneWidget);
      });

      testWidgets('Report Item page should show submit button', (tester) async {
        await tester.pumpWidget(createReportItemPage());
        await tester.pumpAndSettle();

        // Submit button with item type
        expect(find.textContaining('Report'), findsWidgets);
      });

      testWidgets('Report Item page should have media upload section', (
        tester,
      ) async {
        await tester.pumpWidget(createReportItemPage());
        await tester.pumpAndSettle();

        // Media upload area should exist
        expect(find.byIcon(Icons.add_a_photo_rounded), findsOneWidget);
      });

      testWidgets('Report Item page back button should be tappable', (
        tester,
      ) async {
        await tester.pumpWidget(createReportItemPage());
        await tester.pumpAndSettle();

        // Find back button
        final backButton = find.byIcon(Icons.arrow_back_rounded);
        expect(backButton, findsOneWidget);

        // Should be tappable without error
        await tester.tap(backButton);
        await tester.pumpAndSettle();
      });
    });

    group('My Items Page Integration Tests', () {
      Widget createMyItemsPage() {
        return ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(sharedPreferences),
          ],
          child: const MaterialApp(home: MyItemsPage()),
        );
      }

      testWidgets('My Items page should display correctly', (tester) async {
        await tester.pumpWidget(createMyItemsPage());
        await tester.pumpAndSettle();

        // Page should load without error
        expect(find.byType(Scaffold), findsOneWidget);
      });

      testWidgets('My Items page should display page title', (tester) async {
        await tester.pumpWidget(createMyItemsPage());
        await tester.pumpAndSettle();

        // My Items title
        expect(find.text('My Items'), findsOneWidget);
      });

      testWidgets('My Items page should have filter tabs', (tester) async {
        await tester.pumpWidget(createMyItemsPage());
        await tester.pumpAndSettle();

        // Filter tabs for All, Lost, Found
        expect(find.text('All'), findsOneWidget);
      });
    });
  });
}
