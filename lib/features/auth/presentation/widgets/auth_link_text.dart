import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/theme_extensions.dart';

class AuthLinkText extends StatelessWidget {
  final String text;
  final String linkText;
  final VoidCallback onTap;

  const AuthLinkText({
    super.key,
    required this.text,
    required this.linkText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: TextStyle(color: context.textSecondary, fontSize: 15),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            linkText,
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }
}
