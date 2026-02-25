import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';

class PageIndicator extends StatelessWidget {
  final int itemCount;
  final int currentPage;
  final Color? activeColor;

  const PageIndicator({
    super.key,
    required this.itemCount,
    required this.currentPage,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        itemCount,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: currentPage == index ? 40 : 10,
          height: 10,
          decoration: BoxDecoration(
            gradient: currentPage == index
                ? LinearGradient(
                    colors: [
                      activeColor ?? AppColors.primary,
                      (activeColor ?? AppColors.primary).withAlpha(179),
                    ],
                  )
                : null,
            color: currentPage != index ? AppColors.border : null,
            borderRadius: BorderRadius.circular(5),
            boxShadow: currentPage == index
                ? [
                    BoxShadow(
                      color: (activeColor ?? AppColors.primary).withAlpha(102),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
        ),
      ),
    );
  }
}
