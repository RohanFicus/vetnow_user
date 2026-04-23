import 'package:flutter/material.dart';

extension AppThemeColors on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  Color get appBackground => Theme.of(this).scaffoldBackgroundColor;

  Color get appSurface => Theme.of(this).colorScheme.surface;

  Color get appSurfaceVariant =>
      isDarkMode ? const Color(0xFF172033) : const Color(0xFFF8FAFC);

  Color get appText => Theme.of(this).colorScheme.onSurface;

  Color get appMutedText =>
      isDarkMode ? const Color(0xFFB8C0CC) : const Color(0xFF667085);

  Color get appBorder =>
      isDarkMode ? const Color(0xFF2A3650) : const Color(0xFFE1E5EC);

  Color get appSoftPrimary =>
      isDarkMode ? const Color(0xFF102A46) : const Color(0xFFF0F7FF);

  Color get appShadow => isDarkMode
      ? Colors.black.withValues(alpha: 0.24)
      : Colors.black.withValues(alpha: 0.05);
}
