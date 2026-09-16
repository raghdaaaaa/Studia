import 'package:flutter/material.dart';
import '../Theme/app_palette.dart';

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
        color: backgroundColor ?? context.surfaceColor,
        borderRadius: BorderRadius.circular(24),
        border: backgroundColor == Colors.white
            ? Border.all(color: context.accentColor, width: 2)
            : border,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time Range
          Text(
            timeRange,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: context.textSecondaryColor,
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
              color: isCompleted
                  ? context.textSecondaryColor
                  : context.accentColor,
              decoration:
                  isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
              decorationColor: context.accentColor,
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
                            ? context.accentColor
                            : context.surfaceColor,
                        width: 2,
                      ),
                    ),
                    child: isCompleted
                        ? Icon(
                            Icons.check,
                            size: 18,
                            color: context.accentColor,
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
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: context.accentColor,
                      ),
                    ),
                  ],
                )
              else
                const SizedBox.shrink(),

              const SizedBox(width: 12),

              // Focus Button
              if (showFocusButton)
                GestureDetector(
                  onTap: onFocusTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: context.primaryColor,
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