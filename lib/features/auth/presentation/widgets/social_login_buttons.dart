import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../app/theme/app_colors.dart';

class SocialLoginButtons extends StatelessWidget {
  final VoidCallback onGoogleTap;
  final VoidCallback onAppleTap;

  const SocialLoginButtons({
    super.key,
    required this.onGoogleTap,
    required this.onAppleTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onGoogleTap,
            icon: SvgPicture.asset(
              'assets/icons/google_logo.svg',
              width: 20,
              height: 20,
              colorFilter: isDarkMode
                  ? const ColorFilter.mode(
                      AppColors.darkTextPrimary,
                      BlendMode.srcIn,
                    )
                  : null,
            ),
            label: const Text('Google'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onAppleTap,
            icon: SvgPicture.asset(
              'assets/icons/apple_logo.svg',
              width: 20,
              height: 20,
              colorFilter: isDarkMode
                  ? const ColorFilter.mode(
                      AppColors.darkTextPrimary,
                      BlendMode.srcIn,
                    )
                  : null,
            ),
            label: const Text('Apple'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
