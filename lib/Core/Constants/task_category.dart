import 'package:flutter/material.dart';
import 'app_color.dart';
import 'app_strings.dart';

class TaskCategory {
  const TaskCategory._();

  static const String high = 'high';
  static const String medium = 'medium';
  static const String low = 'low';

  static const List<String> priorities = [high, medium, low];

  static String label(String priority) {
    switch (priority) {
      case high:
        return AppStrings.addTaskDevelopment;
      case medium:
        return AppStrings.addTaskDesign;
      default:
        return AppStrings.addTaskStudy;
    }
  }

  static Color background(String priority, {bool isDark = false}) {
    if (isDark) {
      switch (priority) {
        case high:
          return AppColors.darkSurfaceStrong;
        case medium:
          return AppColors.darkSurface;
        default:
          return AppColors.darkBackground;
      }
    }
    switch (priority) {
      case high:
        return AppColors.primaryCardColor;
      case medium:
        return AppColors.primaryCard10Color;
      default:
        return AppColors.backgroundColor;
    }
  }

  static bool showBorder(String priority) => priority == low;

  static Color border(String priority, {bool isDark = false}) {
    final base =
        isDark ? AppColors.darkSurfaceStrong : AppColors.primaryColor;
    return base.withValues(alpha: 0.7);
  }
}