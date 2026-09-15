import 'package:flutter/material.dart';
import '../../Core/Constants/app_color.dart';
import '../../Core/Constants/assets.dart';
import '../../Core/Routing/routes.dart';

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const AppBottomNavBar({
    super.key,
    this.currentIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 65,
      shape: const CircularNotchedRectangle(),
      notchMargin: 15,
      color: Colors.white,
      elevation: 40,
      padding: EdgeInsets.zero,
      child: Row(
        children: [
          Expanded(child: _navItem(context, AppAssets.frame1, index: 0, route: AppRoutes.homeScreen)),
          Expanded(child: _navItem(context, AppAssets.date, index: 1, route: AppRoutes.scheduleScreen)),
          const SizedBox(width: 70),
          Expanded(child: _navItem(context, AppAssets.frame4, index: 3, route: AppRoutes.productivityScreen)),
          Expanded(child: _navItem(context, AppAssets.frame5, index: 4, route: AppRoutes.profileScreen)),
        ],
      ),
    );
  }

  Widget _navItem(BuildContext context, String asset, {required int index, required String route}) {
    final isActive = currentIndex == index;
    return GestureDetector(
      onTap: () {
        if (currentIndex != index) {
          Navigator.pushReplacementNamed(context, route);
        }
      },
      child: Center(
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(
            isActive ? AppColors.primaryColor : Colors.grey.shade400,
            BlendMode.srcIn,
          ),
          child: Image.asset(
            asset,
            width: 28,
            height: 28,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}