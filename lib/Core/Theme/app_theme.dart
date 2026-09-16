import 'package:flutter/material.dart';
import 'package:studia/Core/Constants/app_color.dart';

class AppTheme {
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

    dialogTheme: const DialogThemeData(
      backgroundColor: AppColors.white,
      surfaceTintColor: Colors.transparent,
    ),

    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.white,
      surfaceTintColor: Colors.transparent,
    ),

    snackBarTheme: const SnackBarThemeData(
      backgroundColor: AppColors.primaryCardColor,
      contentTextStyle: TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500,
        color: AppColors.primaryColor,
      ),
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
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkTextPrimary,
      error: Color(0xFFCF6679),
      onError: AppColors.black,
    ),

    textTheme: const TextTheme().apply(
      bodyColor: AppColors.darkTextPrimary,
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
      fillColor: AppColors.darkInputFill,
      hintStyle: const TextStyle(color: AppColors.darkTextSecondary),
      labelStyle: const TextStyle(color: AppColors.darkTextPrimary),
      helperStyle: const TextStyle(color: AppColors.darkTextSecondary),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.darkBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primaryCardColor),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.darkBorder),
      ),
    ),

    dividerTheme: const DividerThemeData(color: AppColors.darkBorder),

    dialogTheme: const DialogThemeData(
      backgroundColor: AppColors.darkCard,
      surfaceTintColor: Colors.transparent,
    ),

    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.darkCard,
      surfaceTintColor: Colors.transparent,
    ),

    snackBarTheme: const SnackBarThemeData(
      backgroundColor: AppColors.darkCard,
      contentTextStyle: TextStyle(color: AppColors.darkTextPrimary),
    ),
  );
}
