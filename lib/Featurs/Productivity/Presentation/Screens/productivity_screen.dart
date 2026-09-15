import 'package:flutter/material.dart';
import 'package:studia/Featurs/Add_Task/Data/Models/task_model.dart';
import 'package:studia/Featurs/Add_Task/Data/Services/task_service.dart';
import '../../../../Core/Constants/app_color.dart';
import '../../../../Core/Constants/app_strings.dart';
import '../../../../Core/Constants/assets.dart';
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
              final tasks = snapshot.data ?? [];

              final completedCount =
                  tasks.where((task) => task.isCompleted).length;
              final totalCount = tasks.length;

              final now = DateTime.now();
              final activeIndex = now.weekday - 1;
              final dailyFractions = _weeklyFractions(tasks, now);

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
                  const AchievementCard(
                    icon: AppAssets.rewaed,
                    title: AppStrings.productivitySevenDaysStreak,
                    subtitle: AppStrings.productivityStreakSubtitle,
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