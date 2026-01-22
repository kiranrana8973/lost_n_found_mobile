import 'package:flutter/material.dart';
import '../../domain/entities/onboarding_item.dart';
import '../../../../app/theme/app_colors.dart';

class OnboardingContent extends StatelessWidget {
  final OnboardingItem item;

  const OnboardingContent({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Responsive sizes based on screen dimensions
    final outerCircleSize = screenWidth * 0.65 > 280 ? 280.0 : screenWidth * 0.65;
    final middleCircleSize = outerCircleSize * 0.857; // 240/280 ratio
    final innerCircleSize = outerCircleSize * 0.714; // 200/280 ratio
    final iconSize = innerCircleSize * 0.45; // 90/200 ratio

    // Responsive text sizes
    final titleFontSize = screenWidth < 360 ? 26.0 : 32.0;
    final descFontSize = screenWidth < 360 ? 15.0 : 17.0;
    final verticalSpacing = screenHeight < 700 ? 40.0 : 60.0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth < 360 ? 24.0 : 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated Icon Container
          Container(
            width: outerCircleSize,
            height: outerCircleSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  item.color.withAlpha(26), // 10% opacity
                  item.color.withAlpha(13), // 5% opacity
                ],
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer Ring
                Container(
                  width: middleCircleSize,
                  height: middleCircleSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: item.color.withAlpha(51), // 20% opacity
                      width: 2,
                    ),
                  ),
                ),
                // Inner Ring
                Container(
                  width: innerCircleSize,
                  height: innerCircleSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: item.gradientColors,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: item.color.withAlpha(102), // 40% opacity
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Icon(
                    item.icon,
                    size: iconSize,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: verticalSpacing),

          // Title
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              item.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                height: 1.2,
                letterSpacing: -0.5,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Description
          Text(
            item.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: descFontSize,
              height: 1.6,
              color: AppColors.textSecondary,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
