import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/theme_extensions.dart';

class ItemActionBar extends StatelessWidget {
  final bool isLost;
  final VoidCallback onMessageTap;
  final VoidCallback onActionTap;

  const ItemActionBar({
    super.key,
    required this.isLost,
    required this.onMessageTap,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        boxShadow: [
          BoxShadow(
            color: context.isDarkMode
                ? Colors.black.withAlpha(40)
                : Colors.black.withAlpha(13),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(26),
                borderRadius: BorderRadius.circular(16),
              ),
              child: IconButton(
                onPressed: onMessageTap,
                icon: Icon(
                  Icons.chat_bubble_rounded,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: GestureDetector(
                onTap: onActionTap,
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: isLost
                        ? AppColors.foundGradient
                        : AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: AppColors.buttonShadow,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isLost
                            ? Icons.check_circle_rounded
                            : Icons.pan_tool_rounded,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        isLost ? 'I Found This Item' : 'Claim This Item',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
