import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/features/dashboard/presentation/widgets/filter_tabs.dart';

void main() {
  group('FilterTabs', () {
    testWidgets('renders all filter labels', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FilterTabs(
              filters: const ['All', 'Lost', 'Found'],
              selectedIndex: 0,
              onFilterChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('All'), findsOneWidget);
      expect(find.text('Lost'), findsOneWidget);
      expect(find.text('Found'), findsOneWidget);
    });

    testWidgets('calls onFilterChanged when tab is tapped', (tester) async {
      int? selectedIndex;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FilterTabs(
              filters: const ['All', 'Lost', 'Found'],
              selectedIndex: 0,
              onFilterChanged: (index) => selectedIndex = index,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Lost'));
      expect(selectedIndex, 1);
    });

    testWidgets('calls onFilterChanged with correct index for Found', (
      tester,
    ) async {
      int? selectedIndex;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FilterTabs(
              filters: const ['All', 'Lost', 'Found'],
              selectedIndex: 0,
              onFilterChanged: (index) => selectedIndex = index,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Found'));
      expect(selectedIndex, 2);
    });
  });
}
