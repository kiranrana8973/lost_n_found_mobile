import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/features/dashboard/presentation/widgets/search_bar_widget.dart';

void main() {
  group('SearchBarWidget', () {
    testWidgets('renders with default hint text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: SearchBarWidget())),
      );

      expect(find.text('Search items...'), findsOneWidget);
    });

    testWidgets('renders with custom hint text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: SearchBarWidget(hintText: 'Find something')),
        ),
      );

      expect(find.text('Find something'), findsOneWidget);
    });

    testWidgets('renders search icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: SearchBarWidget())),
      );

      expect(find.byIcon(Icons.search_rounded), findsOneWidget);
    });

    testWidgets('renders filter icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: SearchBarWidget())),
      );

      expect(find.byIcon(Icons.tune_rounded), findsOneWidget);
    });

    testWidgets('calls onChanged when text is entered', (tester) async {
      String? changedText;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchBarWidget(onChanged: (value) => changedText = value),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'wallet');
      expect(changedText, 'wallet');
    });
  });
}
