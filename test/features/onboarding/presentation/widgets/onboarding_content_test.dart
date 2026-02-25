import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/features/onboarding/domain/entities/onboarding_item.dart';
import 'package:lost_n_found/features/onboarding/presentation/widgets/onboarding_content.dart';

void main() {
  group('OnboardingContent', () {
    final testItem = OnboardingItem(
      title: 'Report Lost Items',
      description: 'Quickly report items you have lost',
      icon: Icons.search,
      color: Colors.blue,
      gradientColors: [Colors.blue, Colors.lightBlue],
    );

    testWidgets('renders title text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: OnboardingContent(item: testItem)),
        ),
      );

      expect(find.text('Report Lost Items'), findsOneWidget);
    });

    testWidgets('renders description text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: OnboardingContent(item: testItem)),
        ),
      );

      expect(find.text('Quickly report items you have lost'), findsOneWidget);
    });

    testWidgets('renders icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: OnboardingContent(item: testItem)),
        ),
      );

      expect(find.byIcon(Icons.search), findsOneWidget);
    });
  });
}
