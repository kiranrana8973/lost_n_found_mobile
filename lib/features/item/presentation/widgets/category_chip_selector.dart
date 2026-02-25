import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/theme_extensions.dart';
import '../../../category/domain/entities/category_entity.dart';
import '../../domain/entities/item_entity.dart';

class CategoryChipSelector extends StatelessWidget {
  final List<CategoryEntity> categories;
  final String? selectedCategoryId;
  final ItemType itemType;
  final ValueChanged<String> onCategorySelected;

  const CategoryChipSelector({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.itemType,
    required this.onCategorySelected,
  });

  IconData _getIconForCategoryName(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'electronics':
        return Icons.devices_rounded;
      case 'personal':
        return Icons.person_rounded;
      case 'accessories':
        return Icons.watch_rounded;
      case 'documents':
        return Icons.description_rounded;
      case 'keys':
        return Icons.key_rounded;
      case 'bags':
        return Icons.shopping_bag_rounded;
      case 'clothing':
        return Icons.checkroom_rounded;
      case 'sports':
        return Icons.sports_basketball_rounded;
      case 'books':
        return Icons.menu_book_rounded;
      case 'wallet':
        return Icons.account_balance_wallet_rounded;
      case 'phone':
        return Icons.phone_android_rounded;
      case 'laptop':
        return Icons.laptop_rounded;
      case 'jewelry':
        return Icons.diamond_rounded;
      case 'eyewear':
        return Icons.visibility_rounded;
      case 'other':
        return Icons.more_horiz_rounded;
      default:
        return Icons.category_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.surfaceColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: context.softShadow,
        ),
        child: Center(
          child: Text(
            'Loading categories...',
            style: TextStyle(color: context.textSecondary),
          ),
        ),
      );
    }

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: categories.map((category) {
        final isSelected = selectedCategoryId == category.categoryId;
        return GestureDetector(
          onTap: () {
            if (category.categoryId != null) {
              onCategorySelected(category.categoryId!);
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? (itemType == ItemType.lost
                        ? AppColors.lostGradient
                        : AppColors.foundGradient)
                  : null,
              color: isSelected ? null : context.surfaceColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: context.softShadow,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getIconForCategoryName(category.name),
                  size: 18,
                  color: isSelected ? Colors.white : context.textSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  category.name,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : context.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
