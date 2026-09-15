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

                  const HomeHeader(),

                  const SizedBox(height: 40),

                  ProgressCard(
                    progress: _calculateProgress(tasks),
                    message: AppStrings.homeProgressTitle,
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

  double _calculateProgress(List<TaskModel> tasks) {
    if (tasks.isEmpty) {
      return 0;
    }

    final completedTasks =
        tasks.where((task) => task.isCompleted).length;

    return completedTasks / tasks.length;
  }
}