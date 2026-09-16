import 'package:flutter/material.dart';

import '../../../../Core/Constants/assets.dart';
import '../../../../Core/Constants/task_category.dart';
import '../../../../Core/Theme/app_palette.dart';
import 'package:studia/Featurs/Add_Task/Data/Models/task_model.dart';

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
                  context: context,
                  task: firstTask,
                  image: _getTaskImage(firstTask),
                  isTall: true,
                )
              else
                _buildEmptyCard(context),
              const SizedBox(height: 10),
              if (tasks.length > 3)
                _buildViewMoreCard(context, tasks.length - 3)
              else
                _buildEmptyCard(context),
            ],
          ),
        ),
        const SizedBox(width: 25),
        Expanded(
          child: Column(
            children: [
              if (secondTask != null)
                _buildTaskCard(
                  context: context,
                  task: secondTask,
                  hasShadow: true,
                )
              else
                _buildEmptyCard(context),
              const SizedBox(height: 6),
              if (thirdTask != null)
                _buildTaskCard(
                  context: context,
                  task: thirdTask,
                  image: _getTaskImage(thirdTask),
                  isTall: true,
                )
              else
                _buildEmptyCard(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTaskCard({
    required BuildContext context,
    required TaskModel task,
    String? image,
    bool hasShadow = false,
    bool isTall = false,
  }) {
    final cardColor = TaskCategory.background(
      task.category,
      isDark: context.isDarkMode,
    );

    return Container(
      width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 22,
        ),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(30),
          border: TaskCategory.showBorder(task.category)
              ? Border.all(
                  color: TaskCategory.border(
                    task.category,
                    isDark: context.isDarkMode,
                  ),
                  width: 1.5,
                )
              : null,
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
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: context.textPrimaryColor,
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
                color: context.textPrimaryColor.withAlpha(150),
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
    );
  }

  Widget _buildEmptyCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 35,
      ),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: Text(
          'No task yet',
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Poppins',
            color: context.textSecondaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildViewMoreCard(BuildContext context, int remainingTasks) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 35,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: context.primaryColor,
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




