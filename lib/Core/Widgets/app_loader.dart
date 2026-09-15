import 'package:flutter/material.dart';
import '../Constants/app_color.dart';

class AppLoader extends StatelessWidget {
  final double size;

  const AppLoader({super.key, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: const CircularProgressIndicator(
          color: AppColors.primaryColor,
          strokeWidth: 3,
        ),
      ),
    );
  }
}
