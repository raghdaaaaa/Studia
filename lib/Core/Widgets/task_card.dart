import 'package:flutter/material.dart';
import '../Constants/app_color.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String timeRange;
  final String? teamLabel;
  final bool showFocusButton;
  final VoidCallback? onFocusTap;
  final bool isCompleted;
  final bool showCompletionControl;
  final VoidCallback? onCompletionChanged;
  final Color? backgroundColor;
  final Border? border;
  final double? height;



  const TaskCard({
    super.key,
    required this.title,
    required this.timeRange,
    this.teamLabel,
    this.showFocusButton = true,
    this.onFocusTap,
    this.isCompleted = false,
    this.showCompletionControl = false,
    this.onCompletionChanged,
    this.backgroundColor,
    this.border,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: height ?? 160),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.primaryCard10Color,
        borderRadius: BorderRadius.circular(24),
        border: backgroundColor == Colors.white
            ? Border.all(color: AppColors.primaryColor, width: 2)
            : border,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time Range
          Text(
            timeRange,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),

          // Title
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
              fontSize: 23,
              color:
                  isCompleted ? AppColors.textSecondary : AppColors.primaryColor,
              decoration:
                  isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
              decorationColor: AppColors.primaryColor,
            ),
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (showCompletionControl)
                GestureDetector(
                  onTap: onCompletionChanged,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isCompleted
                            ? AppColors.primaryColor
                            : AppColors.primaryCard10Color,
                        width: 2,
                      ),
                    ),
                    child: isCompleted
                        ? const Icon(
                            Icons.check,
                            size: 18,
                            color: AppColors.primaryColor,
                          )
                        : null,
                  ),
                ),
              if (teamLabel != null)
                Row(
                  children: [
                     const SizedBox(width: 3),
                    Text(
                      teamLabel!,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                )
              else
                const SizedBox.shrink(),

              if (showCompletionControl)
                GestureDetector(
                  onTap: onCompletionChanged,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isCompleted
                            ? AppColors.primaryColor
                            : AppColors.primaryCard10Color,
                        width: 2,
                      ),
                    ),
                    child: isCompleted
                        ? const Icon(
                            Icons.check,
                            size: 18,
                            color: AppColors.primaryColor,
                          )
                        : null,
                  ),
                ),
              const SizedBox(width: 12),

              // Focus Button
              if (showFocusButton)
                GestureDetector(
                  onTap: onFocusTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: const Text(
                      'focus mode',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}