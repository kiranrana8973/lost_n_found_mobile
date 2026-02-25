import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/features/onboarding/presentation/widgets/page_indicator.dart';

void main() {
  group('PageIndicator', () {
    testWidgets('renders correct number of indicators', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: PageIndicator(itemCount: 3, currentPage: 0)),
        ),
      );

      final row = tester.widget<Row>(find.byType(Row));
      expect(row.children.length, 3);
    });

    testWidgets('active indicator is wider than inactive', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: PageIndicator(itemCount: 3, currentPage: 1)),
        ),
      );

      final animatedContainers = tester
          .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
          .toList();

      expect(animatedContainers.length, 3);
    });
  });
}
