import 'package:flutter/material.dart';
import '../../../../app/theme/theme_extensions.dart';

class FormSectionHeader extends StatelessWidget {
  final String title;

  const FormSectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: context.textPrimary,
      ),
    );
  }
}
