import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/theme_extensions.dart';

class MyItemCard extends StatelessWidget {
  final String title;
  final String location;
  final String category;
  final String status;
  final bool isLost;
  final String? imageUrl;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const MyItemCard({
    super.key,
    required this.title,
    required this.location,
    required this.category,
    required this.status,
    required this.isLost,
    this.imageUrl,
    this.onTap,
    this.onEdit,
    this.onDelete,
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
        return isLost ? AppColors.lostColor : AppColors.foundColor;
      case 'claimed':
        return AppColors.warning;
      case 'resolved':
        return AppColors.claimedColor;
      default:
        return AppColors.textSecondary;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'active':
        return 'Active';
      case 'claimed':
        return 'Claimed';
      case 'resolved':
        return 'Resolved';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isResolved = status == 'resolved';

    return Opacity(
      opacity: isResolved ? 0.6 : 1.0,
      child: Container(
        decoration: BoxDecoration(
          color: context.surfaceColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: context.softShadow,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildMainContent(context),
                  if (!isResolved) _buildActionButtons(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    final isResolved = status == 'resolved';

    return Row(
      children: [
        _buildItemImage(context, isResolved),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitleRow(context),
              const SizedBox(height: 6),
              _buildLocationRow(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildItemImage(BuildContext context, bool isResolved) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        gradient: imageUrl == null
            ? (isResolved
                  ? null
                  : (isLost ? AppColors.lostGradient : AppColors.foundGradient))
            : null,
        color: isResolved && imageUrl == null ? AppColors.claimedColor : null,
        borderRadius: BorderRadius.circular(14),
      ),
      clipBehavior: Clip.antiAlias,
      child: imageUrl != null
          ? CachedNetworkImage(
              imageUrl: imageUrl!,
              fit: BoxFit.cover,
              width: 56,
              height: 56,
              memCacheHeight: 112,
              memCacheWidth: 112,
              placeholder: (context, url) => Container(
                decoration: BoxDecoration(
                  gradient: isLost
                      ? AppColors.lostGradient
                      : AppColors.foundGradient,
                ),
              ),
              errorWidget: (context, url, error) => Container(
                decoration: BoxDecoration(
                  gradient: isLost
                      ? AppColors.lostGradient
                      : AppColors.foundGradient,
                ),
                child: Icon(
                  _getCategoryIcon(category),
                  color: Colors.white,
                  size: 26,
                ),
              ),
            )
          : Icon(_getCategoryIcon(category), color: Colors.white, size: 26),
    );
  }

  Widget _buildTitleRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: context.textPrimary,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: _getStatusColor(status).withAlpha(26),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            _getStatusText(status),
            style: TextStyle(
              fontSize: 11,
              color: _getStatusColor(status),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationRow(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.location_on_rounded, size: 14, color: context.textSecondary),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            location,
            style: TextStyle(fontSize: 13, color: context.textSecondary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 12),
        Divider(color: context.dividerColor),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: onEdit,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(26),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.edit_rounded,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Edit',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: onDelete,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.error.withAlpha(26),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.delete_rounded,
                        size: 16,
                        color: AppColors.error,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Delete',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.error,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
