import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/features/item/presentation/pages/item_detail_page.dart';

void main() {
  Widget buildWidget({
    String title = 'Lost Wallet',
    String location = 'Library 2F',
    String category = 'Personal',
    bool isLost = true,
    String description = 'Black leather wallet with ID inside',
    String reportedBy = 'John Doe',
    String? imageUrl,
  }) {
    return MaterialApp(
      home: ItemDetailPage(
        title: title,
        location: location,
        category: category,
        isLost: isLost,
        description: description,
        reportedBy: reportedBy,
        imageUrl: imageUrl,
      ),
    );
  }

  group('ItemDetailPage', () {
    testWidgets('renders item details correctly', (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.text('Lost Wallet'), findsOneWidget);
      expect(find.text('Library 2F'), findsOneWidget);
      expect(find.text('Personal'), findsOneWidget);
    });

    testWidgets('shows description text', (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.text('Black leather wallet with ID inside'), findsOneWidget);
    });

    testWidgets('shows reporter info', (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.text('John Doe'), findsOneWidget);
    });

    testWidgets('renders back button', (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
    });

    testWidgets('renders share and bookmark actions', (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.byIcon(Icons.share_rounded), findsOneWidget);
      expect(find.byIcon(Icons.bookmark_border_rounded), findsOneWidget);
    });

    testWidgets('renders found item correctly', (tester) async {
      await tester.pumpWidget(buildWidget(
        title: 'Found Phone',
        isLost: false,
        category: 'Electronics',
      ));

      expect(find.text('Found Phone'), findsOneWidget);
      expect(find.text('Electronics'), findsOneWidget);
    });
  });
}
