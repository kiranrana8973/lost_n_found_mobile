import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/theme_extensions.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../widgets/info_chip.dart';
import '../widgets/item_detail_header.dart';
import '../widgets/item_action_bar.dart';
import '../widgets/reporter_info_card.dart';
import '../widgets/description_card.dart';

class ItemDetailPage extends StatelessWidget {
  final String title;
  final String location;
  final String category;
  final bool isLost;
  final String? description;
  final String reportedBy;
  final String? imageUrl;

  const ItemDetailPage({
    super.key,
    required this.title,
    required this.location,
    required this.category,
    required this.isLost,
    this.description,
    required this.reportedBy,
    this.imageUrl,
  });

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Electronics':
        return Icons.devices_rounded;
      case 'Personal':
        return Icons.person_rounded;
      case 'Accessories':
        return Icons.watch_rounded;
      case 'Documents':
        return Icons.description_rounded;
      case 'Keys':
        return Icons.key_rounded;
      case 'Bags':
        return Icons.backpack_rounded;
      default:
        return Icons.inventory_2_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: _buildBackButton(context),
            actions: _buildActions(context),
            flexibleSpace: FlexibleSpaceBar(
              background: ItemDetailHeader(
                imageUrl: imageUrl,
                category: category,
                isLost: isLost,
                categoryIcon: _getCategoryIcon(category),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: context.backgroundColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Transform.translate(
                offset: const Offset(0, -24),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitleCard(context),
                      const SizedBox(height: 20),
                      DescriptionCard(description: description),
                      const SizedBox(height: 20),
                      ReporterInfoCard(
                        reportedBy: reportedBy,
                        isLost: isLost,
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: ItemActionBar(
        isLost: isLost,
        onMessageTap: () {},
        onActionTap: () => _showClaimDialog(context),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          decoration: BoxDecoration(
            color: context.surfaceColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: context.softShadow,
          ),
          child: Icon(
            Icons.arrow_back_rounded,
            color: context.textPrimary,
          ),
        ),
      ),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    return [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 44,
          decoration: BoxDecoration(
            color: context.surfaceColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: context.softShadow,
          ),
          child: Icon(
            Icons.share_rounded,
            color: context.textPrimary,
            size: 22,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Container(
          width: 44,
          decoration: BoxDecoration(
            color: context.surfaceColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: context.softShadow,
          ),
          child: Icon(
            Icons.bookmark_border_rounded,
            color: context.textPrimary,
            size: 22,
          ),
        ),
      ),
    ];
  }

  Widget _buildTitleCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: context.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: context.textPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(26),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  category,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          InfoChip(
            icon: Icons.location_on_rounded,
            text: location,
          ),
        ],
      ),
    );
  }

  void _showClaimDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: isLost
                    ? AppColors.foundGradient
                    : AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                isLost ? Icons.check_circle_rounded : Icons.pan_tool_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                isLost
                    ? (l10n?.foundThisItem ?? 'Found This Item?')
                    : (l10n?.claimItemTitle ?? 'Claim Item'),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Text(
          isLost
              ? (l10n?.foundItemDialogContent ?? 'You will be connected with the owner to return the item. Continue?')
              : (l10n?.claimItemDialogContent ?? 'Please provide proof of ownership to claim this item.'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              l10n?.cancel ?? 'Cancel',
              style: TextStyle(color: context.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              SnackbarUtils.showSuccess(
                context,
                isLost
                    ? (l10n?.ownerNotified ?? 'Owner has been notified!')
                    : (l10n?.claimRequestSent ?? 'Claim request sent!'),
              );
            },
            child: Text(
              l10n?.continueText ?? 'Continue',
              style: TextStyle(
                color: isLost ? AppColors.foundColor : AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
