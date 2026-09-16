import 'package:flutter/material.dart';
import '../../../../Core/Theme/app_palette.dart';
import '../../../../Core/Constants/app_strings.dart';
import '../../../../Core/Widgets/app_scaffold.dart';
import 'package:studia/Featurs/Add_Task/Data/Services/task_service.dart';
import 'package:studia/Featurs/Add_Task/Data/Models/task_model.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskService = TaskService();

    return AppScaffold(
      currentNavIndex: 0,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.notificationsTitle,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w800,
                  fontSize: 30,
                  color: context.accentColor,
                ),
              ),
              const SizedBox(height: 30),
              StreamBuilder<List<TaskModel>>(
                stream: taskService.getTasks(),
                builder: (context, snapshot) {
                  final tasks = snapshot.data ?? [];
                  final now = DateTime.now();

                  final pendingToday = tasks.where((task) {
                    final d = task.date;
                    return !task.isCompleted &&
                        d.year == now.year &&
                        d.month == now.month &&
                        d.day == now.day;
                  }).toList();

                  if (pendingToday.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 80),
                      child: Center(
                        child: Text(
                          AppStrings.notificationsEmpty,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            color: context.textSecondaryColor,
                          ),
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: [
                      for (final task in pendingToday)
                        _buildNotificationTile(context, task),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationTile(BuildContext context, TaskModel task) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: context.accentColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: context.accentColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_formatDate(task.date)}  •  ${task.time}',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    color: context.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

