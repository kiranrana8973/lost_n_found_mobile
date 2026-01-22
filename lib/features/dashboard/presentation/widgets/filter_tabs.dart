import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/theme_extensions.dart';

class FilterTabs extends StatelessWidget {
  final List<String> filters;
  final int selectedIndex;
  final ValueChanged<int> onFilterChanged;

  const FilterTabs({
    super.key,
    required this.filters,
    required this.selectedIndex,
    required this.onFilterChanged,
  });

  Gradient? _getGradientForIndex(int index, bool isSelected) {
    if (!isSelected) return null;
    if (index == 0) return AppColors.primaryGradient;
    if (index == 1) return AppColors.lostGradient;
    return AppColors.foundGradient;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: context.softShadow,
      ),
      child: Row(
        children: List.generate(filters.length, (index) {
          final isSelected = selectedIndex == index;
          final gradient = _getGradientForIndex(index, isSelected);

          return Expanded(
            child: GestureDetector(
              onTap: () => onFilterChanged(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    filters[index],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : context.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
