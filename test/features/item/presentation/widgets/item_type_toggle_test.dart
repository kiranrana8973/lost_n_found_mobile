import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/features/item/domain/entities/item_entity.dart';
import 'package:lost_n_found/features/item/presentation/widgets/item_type_toggle.dart';

void main() {
  group('ItemTypeToggle', () {
    testWidgets('renders Lost and Found options', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ItemTypeToggle(
              selectedType: ItemType.lost,
              onTypeChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('I Lost Something'), findsOneWidget);
      expect(find.text('I Found Something'), findsOneWidget);
    });

    testWidgets('calls onTypeChanged with found when Found is tapped',
        (tester) async {
      ItemType? selectedType;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ItemTypeToggle(
              selectedType: ItemType.lost,
              onTypeChanged: (type) => selectedType = type,
            ),
          ),
        ),
      );

      await tester.tap(find.text('I Found Something'));
      expect(selectedType, ItemType.found);
    });

    testWidgets('calls onTypeChanged with lost when Lost is tapped',
        (tester) async {
      ItemType? selectedType;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ItemTypeToggle(
              selectedType: ItemType.found,
              onTypeChanged: (type) => selectedType = type,
            ),
          ),
        ),
      );

      await tester.tap(find.text('I Lost Something'));
      expect(selectedType, ItemType.lost);
    });
  });
}
