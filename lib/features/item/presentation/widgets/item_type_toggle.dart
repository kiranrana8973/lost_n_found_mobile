import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/theme_extensions.dart';
import '../../domain/entities/item_entity.dart';

class ItemTypeToggle extends StatelessWidget {
  final ItemType selectedType;
  final ValueChanged<ItemType> onTypeChanged;

  const ItemTypeToggle({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
  });

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
        children: [
          Expanded(
            child: _ToggleOption(
              icon: Icons.search_off_rounded,
              label: 'I Lost Something',
              isSelected: selectedType == ItemType.lost,
              gradient: AppColors.lostGradient,
              onTap: () => onTypeChanged(ItemType.lost),
            ),
          ),
          Expanded(
            child: _ToggleOption(
              icon: Icons.check_circle_rounded,
              label: 'I Found Something',
              isSelected: selectedType == ItemType.found,
              gradient: AppColors.foundGradient,
              onTap: () => onTypeChanged(ItemType.found),
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final Gradient gradient;
  final VoidCallback onTap;

  const _ToggleOption({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: isSelected ? gradient : null,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? Colors.white : context.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : context.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
