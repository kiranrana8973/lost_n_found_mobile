import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/theme_extensions.dart';
import '../../../category/domain/entities/category_entity.dart';

class CategoryChipList extends StatelessWidget {
  final List<CategoryEntity> categories;
  final String? selectedCategoryId;
  final ValueChanged<String?> onCategorySelected;

  const CategoryChipList({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  IconData _getCategoryIcon(String categoryName) {
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
        return Icons.backpack_rounded;
      default:
        return Icons.inventory_2_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildAllChip(context);
          }
          return _buildCategoryChip(context, categories[index - 1]);
        },
      ),
    );
  }

  Widget _buildAllChip(BuildContext context) {
    final isSelected = selectedCategoryId == null;
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: () => onCategorySelected(null),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            gradient: isSelected ? AppColors.primaryGradient : null,
            color: isSelected ? null : context.surfaceColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: context.softShadow,
          ),
          child: Row(
            children: [
              Icon(
                Icons.apps_rounded,
                size: 18,
                color: isSelected ? Colors.white : context.textSecondary,
              ),
              const SizedBox(width: 8),
              Text(
                'All',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : context.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(BuildContext context, CategoryEntity category) {
    final isSelected = selectedCategoryId == category.categoryId;

    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: () => onCategorySelected(category.categoryId),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            gradient: isSelected ? AppColors.primaryGradient : null,
            color: isSelected ? null : context.surfaceColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: context.softShadow,
          ),
          child: Row(
            children: [
              Icon(
                _getCategoryIcon(category.name),
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
      ),
    );
  }
}
