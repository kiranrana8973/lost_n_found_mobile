import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/features/dashboard/presentation/widgets/empty_items_view.dart';

void main() {
  group('EmptyItemsView', () {
    testWidgets('renders default title and subtitle', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: EmptyItemsView())),
      );

      expect(find.text('No items found'), findsOneWidget);
      expect(
        find.text('Be the first to report a lost or found item!'),
        findsOneWidget,
      );
    });

    testWidgets('renders custom title and subtitle', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyItemsView(
              title: 'Nothing here',
              subtitle: 'Try again later',
            ),
          ),
        ),
      );

      expect(find.text('Nothing here'), findsOneWidget);
      expect(find.text('Try again later'), findsOneWidget);
    });

    testWidgets('renders default icon', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: EmptyItemsView())),
      );

      expect(find.byIcon(Icons.inbox_rounded), findsOneWidget);
    });

    testWidgets('renders custom icon', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: EmptyItemsView(icon: Icons.error)),
        ),
      );

      expect(find.byIcon(Icons.error), findsOneWidget);
    });
  });
}
