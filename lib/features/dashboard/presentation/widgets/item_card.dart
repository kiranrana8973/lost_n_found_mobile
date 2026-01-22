import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/theme_extensions.dart';

class ItemCard extends StatelessWidget {
  final String title;
  final String location;
  final String category;
  final bool isLost;
  final String? imageUrl;
  final VoidCallback? onTap;

  const ItemCard({
    super.key,
    required this.title,
    required this.location,
    required this.category,
    required this.isLost,
    this.imageUrl,
    this.onTap,
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
    return Container(
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
            child: Row(
              children: [
                _buildItemImage(context),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitleRow(context),
                      const SizedBox(height: 8),
                      _buildLocationRow(context),
                      const SizedBox(height: 6),
                      _buildCategoryBadge(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItemImage(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        gradient: imageUrl == null
            ? (isLost ? AppColors.lostGradient : AppColors.foundGradient)
            : null,
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: imageUrl != null
          ? Image.network(
              imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: BoxDecoration(
                    gradient:
                        isLost ? AppColors.lostGradient : AppColors.foundGradient,
                  ),
                  child: Icon(
                    _getCategoryIcon(category),
                    color: Colors.white,
                    size: 28,
                  ),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
            )
          : Icon(
              _getCategoryIcon(category),
              color: Colors.white,
              size: 28,
            ),
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
            color: isLost
                ? AppColors.lostColor.withAlpha(26)
                : AppColors.foundColor.withAlpha(26),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            isLost ? 'Lost' : 'Found',
            style: TextStyle(
              fontSize: 11,
              color: isLost ? AppColors.lostColor : AppColors.foundColor,
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
        Icon(
          Icons.location_on_rounded,
          size: 14,
          color: context.textSecondary,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            location,
            style: TextStyle(
              fontSize: 13,
              color: context.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryBadge() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primary.withAlpha(26),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            category,
            style: TextStyle(
              fontSize: 11,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
