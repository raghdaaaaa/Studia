import 'package:flutter/material.dart';

import '../../../../Core/Constants/app_strings.dart';
import '../../../../Core/Widgets/app_scaffold.dart';
import 'package:studia/Featurs/Add_Task/Data/Services/task_service.dart';
import 'package:studia/Featurs/Add_Task/Data/Models/task_model.dart';
import '../Widgets/home_header.dart';
import '../Widgets/progress_card.dart';
import '../Widgets/schedule_grid.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskService = TaskService();

    return AppScaffold(
      currentNavIndex: 0,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: StreamBuilder<List<TaskModel>>(
            stream: taskService.getTasks(),
            builder: (context, snapshot) {
              final tasks = snapshot.data ?? [];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),

                  HomeHeader(
                    notificationCount: _todayPendingCount(tasks),
                    onBellTap: () => Navigator.pushNamed(
                      context,
                      '/notifications',
                    ),
                  ),

                  const SizedBox(height: 40),

                  ProgressCard(
                    progress: _calculateTodayProgress(tasks),
                    message: _buildTodayProgressMessage(tasks),
                  ),

                  const SizedBox(height: 45),

                  ScheduleGrid(
                    tasks: tasks,
                  ),

                  const SizedBox(height: 130),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  double _calculateTodayProgress(List<TaskModel> tasks) {
    final todayTasks = tasks.where(_isToday).toList();
    if (todayTasks.isEmpty) {
      return 0;
    }

    final completedTasks =
        todayTasks.where((task) => task.isCompleted).length;

    return completedTasks / todayTasks.length;
  }

  String _buildTodayProgressMessage(List<TaskModel> tasks) {
    final todayTasks = tasks.where(_isToday).toList();
    if (todayTasks.isEmpty) {
      return AppStrings.homeProgressNoTasksTitle;
    }

    final percent = (_calculateTodayProgress(tasks) * 100).round();
    return '${AppStrings.homeProgressUnitPrefix}$percent'
        '${AppStrings.homeProgressUnitSuffix}';
  }

  int _todayPendingCount(List<TaskModel> tasks) {
    return tasks
        .where((task) => _isToday(task) && !task.isCompleted)
        .length;
  }

  bool _isToday(TaskModel task) {
    final now = DateTime.now();
    final date = task.date;
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}