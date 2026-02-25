import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/features/auth/presentation/widgets/password_field.dart';

void main() {
  late TextEditingController controller;

  setUp(() {
    controller = TextEditingController();
  });

  tearDown(() {
    controller.dispose();
  });

  Widget buildTestWidget({String? Function(String?)? validator}) {
    return MaterialApp(
      home: Scaffold(
        body: Form(
          child: PasswordField(
            controller: controller,
            labelText: 'Password',
            hintText: 'Enter password',
            validator: validator,
          ),
        ),
      ),
    );
  }

  group('PasswordField', () {
    testWidgets('renders label and hint text', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      expect(find.text('Password'), findsOneWidget);
    });

    testWidgets('renders lock icon', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      expect(find.byIcon(Icons.lock_outline_rounded), findsOneWidget);
    });

    testWidgets('text is obscured by default', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Find the EditableText which holds the actual obscureText property
      final editableText = tester.widget<EditableText>(find.byType(EditableText));
      expect(editableText.obscureText, isTrue);
    });

    testWidgets('toggles visibility when icon is tapped', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Initially obscured - visibility icon shown
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);

      // Tap to show password
      await tester.tap(find.byIcon(Icons.visibility_outlined));
      await tester.pump();

      // Now showing - visibility_off icon shown
      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
    });

    testWidgets('accepts text input', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.enterText(find.byType(TextFormField), 'password123');
      expect(controller.text, 'password123');
    });
  });
}
