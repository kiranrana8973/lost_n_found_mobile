import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/core/services/storage/user_session_service.dart';
import 'package:lost_n_found/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SharedPreferences sharedPreferences;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    sharedPreferences = await SharedPreferences.getInstance();
  });

  Future<void> pumpOnboardingPage(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        ],
        child: const MaterialApp(home: OnboardingPage()),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('OnboardingPage - UI Elements', () {
    testWidgets('should display scaffold', (tester) async {
      await pumpOnboardingPage(tester);

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should display Skip button', (tester) async {
      await pumpOnboardingPage(tester);

      expect(find.text('Skip'), findsOneWidget);
    });

    testWidgets('should display PageView for swipeable content', (
      tester,
    ) async {
      await pumpOnboardingPage(tester);

      expect(find.byType(PageView), findsOneWidget);
    });

    testWidgets('should display first onboarding title', (tester) async {
      await pumpOnboardingPage(tester);

      expect(find.text('Report Lost Items'), findsOneWidget);
    });

    testWidgets('should display first onboarding description', (tester) async {
      await pumpOnboardingPage(tester);

      expect(find.textContaining('Quickly report lost items'), findsOneWidget);
    });

    testWidgets('should display Next button on first page', (tester) async {
      await pumpOnboardingPage(tester);

      expect(find.text('Next'), findsOneWidget);
    });

    testWidgets('should display arrow icon in button', (tester) async {
      await pumpOnboardingPage(tester);

      expect(find.byIcon(Icons.arrow_forward_rounded), findsOneWidget);
    });

    testWidgets('should display travel explore icon', (tester) async {
      await pumpOnboardingPage(tester);

      expect(find.byIcon(Icons.travel_explore_rounded), findsOneWidget);
    });
  });

  group('OnboardingPage - Page Navigation', () {
    testWidgets('should navigate to second page on Next tap', (tester) async {
      await pumpOnboardingPage(tester);

      // Tap Next
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      // Second page content
      expect(find.text('Find & Discover'), findsOneWidget);
    });

    testWidgets('should navigate to third page after two Next taps', (
      tester,
    ) async {
      await pumpOnboardingPage(tester);

      // Tap Next twice
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      // Third page content
      expect(find.text('Connect Instantly'), findsOneWidget);
    });

    testWidgets('should show Get Started on last page', (tester) async {
      await pumpOnboardingPage(tester);

      // Navigate to last page
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      // Button should say Get Started
      expect(find.text('Get Started'), findsOneWidget);
    });

    testWidgets('should allow swiping between pages', (tester) async {
      await pumpOnboardingPage(tester);

      // First page
      expect(find.text('Report Lost Items'), findsOneWidget);

      // Swipe left (use larger offset for larger screen)
      await tester.drag(find.byType(PageView), const Offset(-500, 0));
      await tester.pumpAndSettle();

      // Second page
      expect(find.text('Find & Discover'), findsOneWidget);
    });

    testWidgets('should allow swiping back to previous page', (tester) async {
      await pumpOnboardingPage(tester);

      // Go to second page
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      // Swipe right to go back (use larger offset for larger screen)
      await tester.drag(find.byType(PageView), const Offset(500, 0));
      await tester.pumpAndSettle();

      // First page
      expect(find.text('Report Lost Items'), findsOneWidget);
    });
  });

  group('OnboardingPage - Skip Functionality', () {
    testWidgets('Skip button should be tappable', (tester) async {
      await pumpOnboardingPage(tester);

      // Find Skip button
      final skipButton = find.text('Skip');
      expect(skipButton, findsOneWidget);

      // Tap should not throw error
      await tester.tap(skipButton);
      await tester.pumpAndSettle();
    });
  });

  group('OnboardingPage - Page Indicators', () {
    testWidgets('should have page indicators', (tester) async {
      await pumpOnboardingPage(tester);

      // Page indicators are containers
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('should update indicators when page changes', (tester) async {
      await pumpOnboardingPage(tester);

      // Navigate to second page
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      // Indicators should still be visible
      expect(find.byType(Container), findsWidgets);
    });
  });

  group('OnboardingPage - Onboarding Content', () {
    testWidgets('should display all three onboarding screens', (tester) async {
      await pumpOnboardingPage(tester);

      // First screen
      expect(find.text('Report Lost Items'), findsOneWidget);

      // Navigate to second
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      expect(find.text('Find & Discover'), findsOneWidget);

      // Navigate to third
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      expect(find.text('Connect Instantly'), findsOneWidget);
    });

    testWidgets('each screen should have icon', (tester) async {
      await pumpOnboardingPage(tester);

      // First screen icon
      expect(find.byIcon(Icons.travel_explore_rounded), findsOneWidget);

      // Navigate to second
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.location_searching_rounded), findsOneWidget);

      // Navigate to third
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.forum_rounded), findsOneWidget);
    });
  });

  group('OnboardingPage - Layout', () {
    testWidgets('should have SafeArea', (tester) async {
      await pumpOnboardingPage(tester);

      expect(find.byType(SafeArea), findsOneWidget);
    });

    testWidgets('should have Column layout', (tester) async {
      await pumpOnboardingPage(tester);

      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('should have Expanded for PageView', (tester) async {
      await pumpOnboardingPage(tester);

      expect(find.byType(Expanded), findsWidgets);
    });

    testWidgets('should have Padding for content', (tester) async {
      await pumpOnboardingPage(tester);

      expect(find.byType(Padding), findsWidgets);
    });
  });
}
