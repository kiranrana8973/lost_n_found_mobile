import 'package:flutter/material.dart';
import '../../../../app/theme/theme_extensions.dart';

class EmptyItemsView extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const EmptyItemsView({
    super.key,
    this.title = 'No items found',
    this.subtitle = 'Be the first to report a lost or found item!',
    this.icon = Icons.inbox_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: context.textTertiary.withAlpha(128)),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: context.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(fontSize: 14, color: context.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
