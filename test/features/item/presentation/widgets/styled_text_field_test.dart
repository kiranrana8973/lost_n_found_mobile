import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/features/item/presentation/widgets/styled_text_field.dart';

void main() {
  late TextEditingController controller;

  setUp(() {
    controller = TextEditingController();
  });

  tearDown(() {
    controller.dispose();
  });

  group('StyledTextField', () {
    testWidgets('renders hint text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StyledTextField(
              controller: controller,
              hintText: 'Enter name',
            ),
          ),
        ),
      );

      expect(find.text('Enter name'), findsOneWidget);
    });

    testWidgets('renders prefix icon when provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StyledTextField(
              controller: controller,
              hintText: 'Location',
              prefixIcon: Icons.location_on,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.location_on), findsOneWidget);
    });

    testWidgets('accepts text input', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StyledTextField(
              controller: controller,
              hintText: 'Enter name',
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'Lost Wallet');
      expect(controller.text, 'Lost Wallet');
    });

    testWidgets('validates input with validator', (tester) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: StyledTextField(
                controller: controller,
                hintText: 'Required field',
                validator: (value) =>
                    value == null || value.isEmpty ? 'Field is required' : null,
              ),
            ),
          ),
        ),
      );

      formKey.currentState!.validate();
      await tester.pump();

      expect(find.text('Field is required'), findsOneWidget);
    });
  });
}
