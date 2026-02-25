import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/features/auth/presentation/widgets/auth_link_text.dart';

void main() {
  group('AuthLinkText', () {
    testWidgets('renders text and link text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AuthLinkText(
              text: 'No account? ',
              linkText: 'Sign Up',
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('No account? '), findsOneWidget);
      expect(find.text('Sign Up'), findsOneWidget);
    });

    testWidgets('calls onTap when link text is tapped', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AuthLinkText(
              text: 'No account? ',
              linkText: 'Sign Up',
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Sign Up'));
      expect(tapped, isTrue);
    });
  });
}
