import 'package:flutter/material.dart';
import 'package:studia/Core/Constants/app_color.dart';
import 'package:studia/Core/Routing/routes.dart';
import 'package:studia/Core/Theme/app_palette.dart';

class DebugScreen extends StatelessWidget {
  const DebugScreen({super.key});

  static const List<_DebugItem> _screens = [
    _DebugItem(label: 'Onboarding', route: AppRoutes.onboardingScreen),
    _DebugItem(label: 'Sign In', route: AppRoutes.loginScreen),
    _DebugItem(label: 'Sign Up', route: AppRoutes.signupScreen),
    _DebugItem(label: 'Forgot Password', route: AppRoutes.forgotpasswordScreen),
    
    _DebugItem(label: 'Home', route: AppRoutes.homeScreen),
    _DebugItem(label: 'Schedule', route: AppRoutes.scheduleScreen),
    _DebugItem(label: 'Add Task', route: AppRoutes.addTaskScreen),
    _DebugItem(label: 'Focus Mode', route: AppRoutes.focusModeScreen),
    _DebugItem(label: 'Productivity', route: AppRoutes.productivityScreen),
    _DebugItem(label: 'Profile', route: AppRoutes.profileScreen),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.isDarkMode
          ? AppColors.darkBackground
          : AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppBarTheme.of(context).backgroundColor,
        title: const Text(
          '🛠 Debug — Screen Navigator',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            color: AppColors.white,
          ),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: _screens.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = _screens[index];
          return GestureDetector(
            onTap: () => Navigator.pushNamed(context, item.route),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: context.elevatedCardColor,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.label,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: context.accentColor,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: context.textSecondaryColor,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DebugItem {
  final String label;
  final String route;
  const _DebugItem({required this.label, required this.route});
}
