import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../domain/entities/item_entity.dart';

class GradientSubmitButton extends StatelessWidget {
  final ItemType itemType;
  final bool isLoading;
  final VoidCallback? onTap;

  const GradientSubmitButton({
    super.key,
    required this.itemType,
    required this.isLoading,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          gradient: itemType == ItemType.lost
              ? AppColors.lostGradient
              : AppColors.foundGradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppColors.buttonShadow,
        ),
        child: isLoading
            ? const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    itemType == ItemType.lost
                        ? Icons.campaign_rounded
                        : Icons.add_task_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    itemType == ItemType.lost
                        ? 'Report Lost Item'
                        : 'Report Found Item',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
