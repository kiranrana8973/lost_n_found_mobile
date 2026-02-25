import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/features/dashboard/presentation/widgets/stat_card.dart';

void main() {
  group('StatCard', () {
    testWidgets('renders title and value', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatCard(
              icon: Icons.search,
              title: 'Lost Items',
              value: '12',
              gradient: const LinearGradient(
                colors: [Colors.red, Colors.orange],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Lost Items'), findsOneWidget);
      expect(find.text('12'), findsOneWidget);
    });

    testWidgets('renders icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatCard(
              icon: Icons.check_circle,
              title: 'Found Items',
              value: '5',
              gradient: const LinearGradient(
                colors: [Colors.green, Colors.teal],
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });
  });
}
