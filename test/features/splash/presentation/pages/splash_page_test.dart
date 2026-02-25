import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/features/splash/presentation/pages/splash_page.dart';

void main() {
  group('SplashPage', () {
    testWidgets('renders without error', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SplashPage(),
        ),
      );

      // Pump enough time for animations to complete
      await tester.pump(const Duration(seconds: 2));

      // Verify the splash page builds without errors
      expect(find.byType(SplashPage), findsOneWidget);
    });

    testWidgets('renders app name text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SplashPage(),
        ),
      );

      // Pump a few frames for animations to start
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Lost & Found'), findsOneWidget);
    });

    testWidgets('renders search icon', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SplashPage(),
        ),
      );

      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byIcon(Icons.search_rounded), findsOneWidget);
    });

    testWidgets('shows loading indicator', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SplashPage(),
        ),
      );

      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
