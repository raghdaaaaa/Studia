import 'package:flutter/material.dart';
import '../../Core/Constants/app_color.dart';
import '../../Core/Routing/routes.dart';

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
          color: AppColors.primaryCard10Color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(
          Icons.add,
          color: Color(0xFF3C2117),
          size: 28,
        ),
      ),
    );
  }
}