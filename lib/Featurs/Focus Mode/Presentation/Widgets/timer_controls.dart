import 'package:flutter/material.dart';
import '../../../../Core/Constants/app_color.dart';

class TimerControls extends StatelessWidget {
  final bool isRunning;
  final VoidCallback onStop;
  final VoidCallback onPlayPause;

  const TimerControls({
    super.key,
    required this.isRunning,
    required this.onStop,
    required this.onPlayPause,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Stop Button
        GestureDetector(
          onTap: onStop,
          child: Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryCard10Color,
            ),
            child: const Icon(
              Icons.stop_rounded,
              color: AppColors.primaryColor,
              size: 30,
            ),
          ),
        ),
        const SizedBox(width: 30),

        // Play/Pause Button
        GestureDetector(
          onTap: onPlayPause,
          child: Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryColor,
            ),
            child: Icon(
              isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
              color: AppColors.white,
              size: 30,
            ),
          ),
        ),
      ],
    );
  }
}
