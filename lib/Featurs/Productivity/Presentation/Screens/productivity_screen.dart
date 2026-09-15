import 'package:flutter/material.dart';
import 'package:studia/Featurs/Add_Task/Data/Models/task_model.dart';
import 'package:studia/Featurs/Add_Task/Data/Services/task_service.dart';
import '../../../../Core/Constants/app_color.dart';
import '../../../../Core/Constants/app_strings.dart';
import '../../../../Core/Constants/assets.dart';
import '../../../../Core/Widgets/app_loader.dart';
import '../../../../Core/Widgets/app_scaffold.dart';
import '../../../../Core/Widgets/section_header.dart';
import '../Widgets/achievement_card.dart';
import '../Widgets/stat_card.dart';
import '../Widgets/weekly_chart.dart';

class ProductivityScreen extends StatelessWidget {
  const ProductivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskService = TaskService();

    return AppScaffold(
      currentNavIndex: 3,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
          child: StreamBuilder<List<TaskModel>>(
            stream: taskService.getTasks(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Text(
                    AppStrings.productivityLoadError,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
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

              final completedCount =
                  tasks.where((task) => task.isCompleted).length;
              final totalCount = tasks.length;
              final pendingCount = totalCount - completedCount;
              final completionPercent = totalCount == 0
                  ? 0
                  : ((completedCount / totalCount) * 100).round();

              final now = DateTime.now();
              final activeIndex = now.weekday - 1;
              final dailyFractions = _weeklyFractions(tasks, now);

              final streak = _currentStreak(tasks, now);
              final streakTitle = streak == 1
                  ? '1 ${AppStrings.productivityStreakDay}'
                  : '$streak ${AppStrings.productivityStreakDays}';
              final streakSubtitle = streak <= 0
                  ? AppStrings.productivityStreakSubtitleNone
                  : AppStrings.productivityStreakSubtitleActive;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    AppStrings.productivityTitle,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w800,
                      fontSize: 30,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 30),

                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          value: '$completedCount',
                          label: AppStrings.productivityTasksLabel,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: StatCard(
                          value: '$totalCount',
                          label: AppStrings.productivityTotalTasksLabel,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          value: '$pendingCount',
                          label: AppStrings.productivityPendingLabel,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: StatCard(
                          value: '$completionPercent%',
                          label: AppStrings.productivityCompletionLabel,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),

                  const SectionHeader(
                      title: AppStrings.productivityWeeklyOverview),
                  const SizedBox(height: 16),
                  WeeklyChart(
                    dailyFractions: dailyFractions,
                    activeIndex: activeIndex,
                  ),
                  const SizedBox(height: 60),

                  const SectionHeader(
                      title: AppStrings.productivityRecentAchievement),
                  const SizedBox(height: 16),
                  AchievementCard(
                    icon: AppAssets.rewaed,
                    title: streakTitle,
                    subtitle: streakSubtitle,
                  ),

                  const SizedBox(height: 100),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  int _currentStreak(List<TaskModel> tasks, DateTime now) {
    final completedDates = tasks
        .where((task) => task.isCompleted)
        .map(
          (task) => DateTime(task.date.year, task.date.month, task.date.day),
        )
        .toSet();

    var streak = 0;
    var cursor = DateTime(now.year, now.month, now.day);

    while (completedDates.contains(cursor)) {
      streak++;
      cursor = DateTime(cursor.year, cursor.month, cursor.day - 1);
    }

    return streak;
  }

  List<double> _weeklyFractions(List<TaskModel> tasks, DateTime now) {
    final weekday = now.weekday;
    final startOfWeek = DateTime(now.year, now.month, now.day - (weekday - 1));

    return List.generate(7, (index) {
      final day = DateTime(
        startOfWeek.year,
        startOfWeek.month,
        startOfWeek.day + index,
      );

      final dayTasks = tasks.where((task) {
        final date = task.date;
        return date.year == day.year &&
            date.month == day.month &&
            date.day == day.day;
      }).toList();

      if (dayTasks.isEmpty) return 0;

      final completed = dayTasks.where((task) => task.isCompleted).length;
      return completed / dayTasks.length;
    });
  }
}