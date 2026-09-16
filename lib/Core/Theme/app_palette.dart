import 'package:flutter/material.dart';
import 'package:studia/Core/Constants/app_color.dart';

/// Theme-aware semantic colors.
///
/// In light mode every getter returns exactly the color the app currently
/// uses. In dark mode each getter resolves to the matching dark equivalent,
/// so widgets keep their look without scattering `isDark` checks everywhere.
extension AppPaletteContext on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  /// Brand accent used for text, icons, borders and stroke highlights.
  Color get accentColor =>
      isDarkMode ? AppColors.primaryCardColor : AppColors.primaryColor;

  /// Primary body text color.
  Color get textPrimaryColor =>
      isDarkMode ? AppColors.darkTextPrimary : AppColors.textPrimary;

  /// Secondary / muted text color.
  Color get textSecondaryColor =>
      isDarkMode ? AppColors.darkTextSecondary : AppColors.textSecondary;

  /// Page background. In light mode the app uses a white background on top of
  /// the scaffold, so keep that exactly.
  Color get pageBackgroundColor =>
      isDarkMode ? AppColors.darkBackground : AppColors.white;

  /// Warm cream surface (AppColors.primaryCard10Color) in light mode and the
  /// dark surface in dark mode.
  Color get surfaceColor =>
      isDarkMode ? AppColors.darkSurface : AppColors.primaryCard10Color;

  /// Beige surface (AppColors.primaryCardColor) in light mode and the stronger
  /// dark surface in dark mode.
  Color get surfaceColorStrong =>
      isDarkMode ? AppColors.darkSurfaceStrong : AppColors.primaryCardColor;

  /// White cards in light mode, elevated dark cards in dark mode.
  Color get elevatedCardColor =>
      isDarkMode ? AppColors.darkCard : AppColors.white;

  /// Input field fill used across auth/onboarding fields.
  Color get fieldFillColor =>
      isDarkMode ? AppColors.darkInputFill : AppColors.primaryCardColor;

  /// Muted icon color for inactive UI elements.
  Color get inactiveIconColor =>
      isDarkMode ? AppColors.white.withValues(alpha: 0.34) : Colors.grey.shade400;

  /// Primary semantic color used across the app.
  /// In light mode returns AppColors.primaryColor (0xFF3C2117).
  /// In dark mode returns AppColors.darkSurfaceStrong (0xFF5D4C38).
  Color get primaryColor =>
      isDarkMode ? AppColors.darkSurfaceStrong : AppColors.primaryColor;

  
}