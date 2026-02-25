import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/features/auth/presentation/widgets/auth_header.dart';

void main() {
  Widget buildTestWidget({
    IconData icon = Icons.lock_outline,
    String title = 'Test Title',
    String subtitle = 'Test Subtitle',
  }) {
    return MaterialApp(
      home: Scaffold(
        body: AuthHeader(icon: icon, title: title, subtitle: subtitle),
      ),
    );
  }

  group('AuthHeader', () {
    testWidgets('renders title text', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      expect(find.text('Test Title'), findsOneWidget);
    });

    testWidgets('renders subtitle text', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      expect(find.text('Test Subtitle'), findsOneWidget);
    });

    testWidgets('renders icon', (tester) async {
      await tester.pumpWidget(buildTestWidget(icon: Icons.person));
      expect(find.byIcon(Icons.person), findsOneWidget);
    });
  });
}
