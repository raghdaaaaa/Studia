import 'package:flutter/material.dart';
import '../../../../Core/Constants/app_color.dart';

class WeeklyChart extends StatelessWidget {
  final List<double> dailyFractions;
  final int activeIndex;

  const WeeklyChart({
    super.key,
    required this.dailyFractions,
    required this.activeIndex,
  });

  static const List<String> _days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(15, 24, 20, 25),
      decoration: BoxDecoration(
        color: AppColors.primaryCard10Color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 160,
            width: double.infinity,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.bottomCenter,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(dailyFractions.length, (index) {
                  final isActive = index == activeIndex;
                  return _Bar(
                    heightFactor: dailyFractions[index],
                    isActive: isActive,
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _days.map((day) {
              return Text(
                day,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: AppColors.primaryColor,
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

  const _Bar({required this.heightFactor, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45,
      height: 125 * heightFactor,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primaryColor : AppColors.primaryCardColor,
        borderRadius: BorderRadius.circular(9),
      ),
    );
  }
}