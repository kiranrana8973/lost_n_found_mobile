import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/features/onboarding/presentation/pages/onboarding_page.dart';

void main() {
  const largeSize = Size(1080, 1920);

  Widget buildWidget() {
    return const MaterialApp(home: OnboardingPage());
  }

  group('OnboardingPage', () {
    testWidgets('renders first onboarding screen', (tester) async {
      await tester.binding.setSurfaceSize(largeSize);
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(buildWidget());
      await tester.pump();

      expect(find.text('Report Lost Items'), findsOneWidget);
      expect(find.text('Next'), findsOneWidget);
      expect(find.text('Skip'), findsOneWidget);
    });

    testWidgets('navigates to next page on Next tap', (tester) async {
      await tester.binding.setSurfaceSize(largeSize);
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(buildWidget());
      await tester.pump();

      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      expect(find.text('Find & Discover'), findsOneWidget);
    });

    testWidgets('shows Get Started on last page', (tester) async {
      await tester.binding.setSurfaceSize(largeSize);
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(buildWidget());
      await tester.pump();

      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      expect(find.text('Connect Instantly'), findsOneWidget);
      expect(find.text('Get Started'), findsOneWidget);
    });

    testWidgets('can swipe between pages', (tester) async {
      await tester.binding.setSurfaceSize(largeSize);
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(buildWidget());
      await tester.pump();

      await tester.drag(find.byType(PageView), const Offset(-600, 0));
      await tester.pumpAndSettle();

      expect(find.text('Find & Discover'), findsOneWidget);
    });
  });
}
