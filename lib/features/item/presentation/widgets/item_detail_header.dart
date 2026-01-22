import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';

class ItemDetailHeader extends StatelessWidget {
  final String? imageUrl;
  final String category;
  final bool isLost;
  final IconData categoryIcon;

  const ItemDetailHeader({
    super.key,
    this.imageUrl,
    required this.category,
    required this.isLost,
    required this.categoryIcon,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null) {
      return _buildImageHeader(context);
    }
    return _buildIconHeader(context);
  }

  Widget _buildImageHeader(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          imageUrl!,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              decoration: BoxDecoration(
                gradient: isLost ? AppColors.lostGradient : AppColors.foundGradient,
              ),
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              decoration: BoxDecoration(
                gradient: isLost ? AppColors.lostGradient : AppColors.foundGradient,
              ),
              child: Center(
                child: Icon(categoryIcon, size: 50, color: Colors.white),
              ),
            );
          },
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withAlpha(77),
                Colors.transparent,
                Colors.black.withAlpha(128),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: Center(child: _buildBadge()),
        ),
      ],
    );
  }

  Widget _buildIconHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: isLost ? AppColors.lostGradient : AppColors.foundGradient,
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(51),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(categoryIcon, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(51),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isLost ? Icons.search_off_rounded : Icons.check_circle_rounded,
                    size: 18,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isLost ? 'Lost Item' : 'Found Item',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isLost ? AppColors.lostColor : AppColors.foundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isLost ? Icons.search_off_rounded : Icons.check_circle_rounded,
            size: 18,
            color: Colors.white,
          ),
          const SizedBox(width: 6),
          Text(
            isLost ? 'Lost Item' : 'Found Item',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
