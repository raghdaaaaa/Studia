import 'package:flutter/material.dart';

import '../../../../Core/Constants/assets.dart';
import '../../../../Core/Routing/routes.dart';
import '../../../../Core/Theme/app_palette.dart';
import '../../../Add_Task/Data/Models/task_model.dart';
import '../../../Add_Task/Data/Services/task_service.dart';

class HomeHeader extends StatelessWidget {
  final int notificationCount;
  final VoidCallback? onBellTap;

  const HomeHeader({
    super.key,
    this.notificationCount = 0,
    this.onBellTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "Let's become\nmore ",
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 27,
                    fontWeight: FontWeight.w800,
                    color: context.textPrimaryColor,
                    height: 1.2,
                  ),
                ),
                TextSpan(
                  text: 'Productive',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 27,
                    fontWeight: FontWeight.w800,
                    color: context.accentColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        StreamBuilder<List<TaskModel>>(
          stream: TaskService().getTasks(),
          builder: (context, snapshot) {
            final tasks = snapshot.data ?? [];
            final today = DateTime.now();
            final pendingToday = tasks.where((task) {
              if (task.isCompleted) return false;
              final d = task.date;
              return d.year == today.year &&
                  d.month == today.month &&
                  d.day == today.day;
            }).length;

            return GestureDetector(
              onTap: () => Navigator.pushNamed(
                context,
                AppRoutes.notificationsScreen,
              ),
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    child: Image.asset(
                      AppAssets.notificationBell,
                      width: 30,
                      height: 30,
                      fit: BoxFit.contain,
                    ),
                  ),
                  if (pendingToday > 0)
                    Positioned(
                      right: 8,
                      top: 0,
                      child: Container(
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(9),
                          border: Border.all(color: Colors.white, width: 1.2),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          pendingToday > 99 ? '99+' : '$pendingToday',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
