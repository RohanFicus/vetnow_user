import 'package:flutter/material.dart';

import 'app_color.dart';

class AppTheme {
  static ThemeData lightTheme() {
    final base = ThemeData.light();
    return base.copyWith(
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        surface: Colors.white,
        onSurface: AppColors.text,
      ),
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Color(0xFFF8FAFC),
        foregroundColor: AppColors.text,
        surfaceTintColor: Colors.transparent,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
      ),
      cardTheme: const CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      cardColor: Colors.white,
      dividerColor: const Color(0xFFE1E5EC),
      iconTheme: const IconThemeData(color: AppColors.text),
      textTheme: base.textTheme.apply(
        fontFamily: 'Figtree',
        bodyColor: AppColors.text,
        displayColor: AppColors.text,
      ),
    );
  }

  static ThemeData darkTheme() {
    final base = ThemeData.dark();
    return base.copyWith(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
        surface: const Color(0xFF101827),
        onSurface: const Color(0xFFE8EEF7),
      ),
      scaffoldBackgroundColor: const Color(0xFF0B1020),
      primaryColor: AppColors.primary,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Color(0xFF0B1020),
        foregroundColor: Color(0xFFE8EEF7),
        surfaceTintColor: Colors.transparent,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFF101827),
      ),
      cardTheme: const CardThemeData(
        color: Color(0xFF101827),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      cardColor: const Color(0xFF101827),
      dividerColor: const Color(0xFF2A3650),
      iconTheme: const IconThemeData(color: Color(0xFFE8EEF7)),
      listTileTheme: const ListTileThemeData(
        iconColor: Color(0xFFE8EEF7),
        textColor: Color(0xFFE8EEF7),
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: Color(0xFF101827),
        surfaceTintColor: Colors.transparent,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF101827),
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Color(0xFFB8C0CC),
      ),
      textTheme: base.textTheme.apply(
        fontFamily: 'Figtree',
        bodyColor: const Color(0xFFE8EEF7),
        displayColor: const Color(0xFFE8EEF7),
      ),
    );
  }
}
