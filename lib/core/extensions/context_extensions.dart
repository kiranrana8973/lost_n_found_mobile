import 'package:flutter/material.dart';
import 'package:lost_n_found/core/localization/app_localizations.dart';

extension ContextExtensions on BuildContext {
  // Theme shortcuts
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  // MediaQuery shortcuts
  Size get screenSize => MediaQuery.sizeOf(this);
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;
  EdgeInsets get padding => MediaQuery.paddingOf(this);
  EdgeInsets get viewInsets => MediaQuery.viewInsetsOf(this);

  // Localization shortcut
  AppLocalizations get l10n => AppLocalizations.of(this)!;

  // Keyboard
  bool get isKeyboardOpen => MediaQuery.viewInsetsOf(this).bottom > 0;
  void hideKeyboard() => FocusScope.of(this).unfocus();
}
