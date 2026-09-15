import 'package:flutter/material.dart';

import '../../../../Core/Constants/app_color.dart';
import '../../../../Core/Constants/assets.dart';
import 'package:studia/Featurs/Add_Task/Data/Models/task_model.dart';
import 'package:studia/Featurs/Add_Task/Data/Services/task_service.dart';

class ScheduleGrid extends StatelessWidget {
  final List<TaskModel> tasks;

  const ScheduleGrid({
    super.key,
    required this.tasks,
  });

  @override
  Widget build(BuildContext context) {
    final firstTask = tasks.isNotEmpty ? tasks[0] : null;
    final secondTask = tasks.length > 1 ? tasks[1] : null;
    final thirdTask = tasks.length > 2 ? tasks[2] : null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              if (firstTask != null)
                _buildTaskCard(
                  task: firstTask,
                  image: _getTaskImage(firstTask),
                  isTall: true,
                )
              else
                _buildEmptyCard(),
              const SizedBox(height: 10),
              if (tasks.length > 3)
                _buildViewMoreCard(tasks.length - 3)
              else
                _buildEmptyCard(),
            ],
          ),
        ),
        const SizedBox(width: 25),
        Expanded(
          child: Column(
            children: [
              if (secondTask != null)
                _buildTaskCard(
                  task: secondTask,
                  hasShadow: true,
                )
              else
                _buildEmptyCard(),
              const SizedBox(height: 6),
              if (thirdTask != null)
                _buildTaskCard(
                  task: thirdTask,
                  image: _getTaskImage(thirdTask),
                  isTall: true,
                )
              else
                _buildEmptyCard(),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _toggleTaskCompletion(TaskModel task) async {
    final taskService = TaskService();

    await taskService.updateTaskCompletion(
      taskId: task.id,
      isCompleted: !task.isCompleted,
    );
  }

  Widget _buildTaskCard({
    required TaskModel task,
    String? image,
    bool hasShadow = false,
    bool isTall = false,
  }) {
    final cardColor = _getTaskColor(task.category);

    return GestureDetector(
      onTap: () => _toggleTaskCompletion(task),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 22,
        ),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(30),
          boxShadow: hasShadow || cardColor == Colors.white
              ? [
                  BoxShadow(
                    color: Colors.black.withAlpha(20),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                fontFamily: 'Poppins',
                height: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              task.time,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary.withAlpha(150),
                fontFamily: 'Poppins',
              ),
            ),
            if (image != null) ...[
              const SizedBox(height: 15),
              Center(
                child: Image.asset(
                  image,
                  height: isTall ? 120 : 90,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 35,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryCard10Color,
        borderRadius: BorderRadius.circular(30),
      ),
      child: const Center(
        child: Text(
          'No task yet',
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Poppins',
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildViewMoreCard(int remainingTasks) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 35,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(40),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            "Click to view\nmore",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              height: 1.2,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            "+$remainingTasks Schedule",
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 15,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  Color _getTaskColor(String category) {
    switch (category) {
      case 'high':
        return AppColors.primaryCard10Color;

      case 'medium':
        return AppColors.primaryCardColor;

      case 'low':
        return Colors.white;

      default:
        return AppColors.primaryCard10Color;
    }
  }

  String? _getTaskImage(TaskModel task) {
    switch (task.category) {
      case 'medium':
        return AppAssets.taskSketching;

      case 'high':
        return AppAssets.taskPlan;

      default:
        return null;
    }
  }
}
