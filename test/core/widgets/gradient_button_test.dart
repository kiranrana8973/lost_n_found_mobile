import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/core/widgets/gradient_button.dart';

void main() {
  group('GradientButton', () {
    testWidgets('renders button text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GradientButton(
              text: 'Submit',
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Submit'), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped', (tester) async {
      var pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GradientButton(
              text: 'Submit',
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      expect(pressed, isTrue);
    });

    testWidgets('shows loading indicator when isLoading is true',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GradientButton(
              text: 'Submit',
              isLoading: true,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Submit'), findsNothing);
    });

    testWidgets('does not call onPressed when loading', (tester) async {
      var pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GradientButton(
              text: 'Submit',
              isLoading: true,
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      expect(pressed, isFalse);
    });

    testWidgets('renders icon when provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GradientButton(
              text: 'Submit',
              icon: const Icon(Icons.send),
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.send), findsOneWidget);
    });
  });
}
