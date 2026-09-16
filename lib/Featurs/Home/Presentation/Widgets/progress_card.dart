import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../../../../Core/Constants/app_color.dart';
import '../../../../Core/Theme/app_palette.dart';
import '../../../../Core/Routing/routes.dart';

class ProgressCard extends StatelessWidget {
  final double progress;
  final String message;

  const ProgressCard({
    super.key,
    required this.progress,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
      decoration: BoxDecoration(
        color: context.primaryColor,
        borderRadius: BorderRadius.circular(42),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(60),
            blurRadius: 30,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w600,
              fontFamily: 'Cairo',
              height: 1.3,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 47,
                width: 130,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.scheduleScreen);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryCardColor,
                    foregroundColor: AppColors.textPrimary,
                    elevation: 0,
                    shape: const StadiumBorder(),
                  ),
                  child: const Text(
                    "View Task",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
              ),
              Flexible(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final barWidth =
                        math.min(120.0, constraints.maxWidth);
final filledWidth = math.min(
  barWidth,
  math.max(0.0, (screenWidth - 250) * progress),
);
                    return Stack(
                      children: [
                        Container(
                          width: barWidth,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(40),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        Container(
                          width: filledWidth,
                          height: 10,
                          decoration: BoxDecoration(
                            color: AppColors.primaryCardColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
