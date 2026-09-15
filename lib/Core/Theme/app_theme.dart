import 'package:flutter/material.dart';
import 'package:studia/Core/Constants/app_color.dart';

class AppTheme {
  static const Color _darkSurface = Color(0xFF241713);
  static const Color _darkOnSurface = Color(0xFFFBF4E8);
  static const Color _darkTextSecondary = Color(0xFFC9BBA8);
  static const Color _darkBorder = Color(0xFF3A2A1F);

  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.backgroundColor,
    primaryColor: AppColors.primaryColor,
    fontFamily: 'Inter',

    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryColor,
      primary: AppColors.primaryColor,
      secondary: AppColors.primaryCardColor,
      surface: AppColors.backgroundColor,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.backgroundColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
    ),
  );

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackground,
    primaryColor: AppColors.primaryCardColor,
    fontFamily: 'Inter',

    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryCardColor,
      onPrimary: AppColors.primaryColor,
      secondary: AppColors.secondaryGold,
      onSecondary: AppColors.white,
      surface: _darkSurface,
      onSurface: _darkOnSurface,
      error: Color(0xFFCF6679),
      onError: AppColors.black,
    ),

    textTheme: const TextTheme().apply(
      bodyColor: _darkOnSurface,
      displayColor: AppColors.primaryCardColor,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkBackground,
      foregroundColor: AppColors.primaryCardColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w700,
        fontSize: 22,
        color: AppColors.primaryCardColor,
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _darkSurface,
      hintStyle: const TextStyle(color: _darkTextSecondary),
      labelStyle: const TextStyle(color: _darkOnSurface),
      helperStyle: const TextStyle(color: _darkTextSecondary),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: _darkBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primaryCardColor),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: _darkBorder),
      ),
    ),

    dividerTheme: const DividerThemeData(color: _darkBorder),

    snackBarTheme: const SnackBarThemeData(
      backgroundColor: _darkSurface,
      contentTextStyle: TextStyle(color: _darkOnSurface),
    ),
  );
}
