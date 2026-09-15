import 'package:flutter/material.dart';
import 'package:studia/Featurs/Add_Task/Data/Models/task_model.dart';
import 'package:studia/Featurs/Add_Task/Data/Services/task_service.dart';
import 'package:studia/Featurs/Focus%20Mode/Presentation/Screens/focus_mode_screen.dart';
import 'package:studia/Featurs/Schedule/Presentation/Widgets/day_selector.dart';
import '../../../../Core/Constants/app_color.dart';
import '../../../../Core/Constants/app_strings.dart';
import '../../../../Core/Widgets/app_loader.dart';
import '../../../../Core/Widgets/app_scaffold.dart';
import '../../../../Core/Widgets/section_header.dart';
import '../../../../Core/Widgets/task_card.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskService = TaskService();

    return AppScaffold(
      currentNavIndex: 1,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title + Search
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    AppStrings.scheduleTitle,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w800,
                      fontSize: 30,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: const Icon(
                      Icons.search,
                      color: AppColors.primaryColor,
                      size: 26,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Day Selector
              const DaySelector(),
              const SizedBox(height: 28),

              // Tasks Header
              const SectionHeader(title: AppStrings.scheduleTodayTasks),
              const SizedBox(height: 16),

              // Firestore-powered task list
              StreamBuilder<List<TaskModel>>(
                stream: taskService.getTasks(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text(
                      'Could not load tasks.',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    );
                  }

                  if (!snapshot.hasData) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: AppLoader(),
                    );
                  }

                  final tasks = snapshot.data!;

                  if (tasks.isEmpty) {
                    return Text(
                      'No tasks yet. Tap + to add your first task.',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final task in tasks)
                        _buildTaskCard(context, taskService, task),
                    ],
                  );
                },
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskCard(
    BuildContext context,
    TaskService taskService,
    TaskModel task,
  ) {
    final bgColor = task.category == 'high'
        ? AppColors.primaryCardColor
        : task.category == 'medium'
            ? AppColors.primaryCard10Color
            : AppColors.backgroundColor;

    final showBorder = task.category == 'low';

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: GestureDetector(
        onTap: () {
          taskService.updateTaskCompletion(
            taskId: task.id,
            isCompleted: !task.isCompleted,
          );
        },
        onLongPress: () => _confirmDelete(context, taskService, task),
        child: TaskCard(
          title: task.title,
          isCompleted: task.isCompleted,
          backgroundColor: bgColor,
          border: showBorder
              ? Border.all(
                  color: AppColors.primaryColor.withValues(alpha: 0.7),
                  width: 1.5,
                )
              : null,
          timeRange: '${_formatDate(task.date)}  •  ${task.time}',
          teamLabel: task.category,
          showFocusButton: true,
          onFocusTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FocusModeScreen(
                  taskId: task.id,
                  taskTitle: task.title,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    TaskService taskService,
    TaskModel task,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete task?'),
        content: Text('"${task.title}" will be permanently deleted.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    await taskService.deleteTask(task.id);
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