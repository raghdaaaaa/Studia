import 'package:flutter/material.dart';
import '../../Core/Routing/routes.dart';
import '../../Core/Theme/app_palette.dart';
import '../Constants/app_color.dart';

class AppFab extends StatelessWidget {
  final VoidCallback? onPressed;

  const AppFab({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ?? () {
        Navigator.pushNamed(context, AppRoutes.addTaskScreen);
      },
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          color: AppColors.primaryCardColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          Icons.add,
          color: AppColors.primaryColor,
          size: 28,
        ),
      ),
    );
  }
}