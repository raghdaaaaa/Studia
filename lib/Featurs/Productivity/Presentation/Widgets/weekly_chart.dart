import 'package:flutter/material.dart';
import '../../../../Core/Constants/app_color.dart';
import '../../../../Core/Theme/app_palette.dart';

class WeeklyChart extends StatelessWidget {
  final List<double> dailyFractions;
  final int activeIndex;

  const WeeklyChart({
    super.key,
    required this.dailyFractions,
    required this.activeIndex,
  });

  static const List<String> _days = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  @override
  Widget build(BuildContext context) {
    final hasAnyData = dailyFractions.any((f) => f > 0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(15, 24, 20, 25),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 160,
            width: double.infinity,
            child: hasAnyData
                ? FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children:
                          List.generate(dailyFractions.length, (index) {
                        final isActive = index == activeIndex;
                        return _Bar(
                          heightFactor: dailyFractions[index],
                          isActive: isActive,
                          isDark: context.isDarkMode,
                        );
                      }),
                    ),
                  )
                : Center(
                    child: Text(
                      'Complete tasks to see your\ndaily progress here',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        color: context.textSecondaryColor,
                      ),
                    ),
                  ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _days.map((day) {
              return Text(
                day,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: context.accentColor,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  final double heightFactor;
  final bool isActive;
  final bool isDark;

  const _Bar({
    required this.heightFactor,
    required this.isActive,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive
        ? (context.primaryColor)
        : (isDark ? AppColors.darkSurfaceStrong : AppColors.primaryCardColor);

    return Container(
      width: 45,
      height: 125 * heightFactor,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(9),
      ),
    );
  }
}
