import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/features/auth/presentation/widgets/terms_checkbox.dart';

void main() {
  group('TermsCheckbox', () {
    testWidgets('renders terms text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TermsCheckbox(
              value: false,
              onChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.textContaining('Terms & Conditions'), findsOneWidget);
      expect(find.textContaining('Privacy Policy'), findsOneWidget);
    });

    testWidgets('checkbox reflects value', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TermsCheckbox(
              value: true,
              onChanged: (_) {},
            ),
          ),
        ),
      );

      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, isTrue);
    });

    testWidgets('calls onChanged when checkbox is tapped', (tester) async {
      bool? changedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TermsCheckbox(
              value: false,
              onChanged: (v) => changedValue = v,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(Checkbox));
      expect(changedValue, isTrue);
    });
  });
}
