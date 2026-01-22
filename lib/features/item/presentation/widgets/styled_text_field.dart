import 'package:flutter/material.dart';
import '../../../../app/theme/theme_extensions.dart';

class StyledTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? prefixIcon;
  final int maxLines;
  final String? Function(String?)? validator;

  const StyledTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.prefixIcon,
    this.maxLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: context.softShadow,
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        style: TextStyle(color: context.textPrimary),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: context.textTertiary),
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, color: context.textSecondary)
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
        validator: validator,
      ),
    );
  }
}
