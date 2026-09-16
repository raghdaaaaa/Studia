import 'package:flutter/material.dart';

import '../../../../Core/Constants/app_strings.dart';
import '../../../../Core/Theme/app_palette.dart';
import '../../../../Core/Widgets/app_scaffold.dart';
import '../../../../Core/Widgets/app_loader.dart';
import 'package:studia/Featurs/Add_Task/Data/Services/task_service.dart';
import 'package:studia/Featurs/Add_Task/Data/Models/task_model.dart';
import 'package:studia/Core/Routing/routes.dart';
import '../Widgets/home_header.dart';
import '../Widgets/progress_card.dart';
import '../Widgets/schedule_grid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Stream<List<TaskModel>> _taskStream;

  @override
  void initState() {
    super.initState();
    _taskStream = TaskService().getTasks();
  }

  void _retry() {
    setState(() {
      _taskStream = TaskService().getTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentNavIndex: 0,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: StreamBuilder<List<TaskModel>>(
            stream: _taskStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: Column(
                    children: [
                      Text(
                        AppStrings.homeLoadError,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          color: context.textSecondaryColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton(
                        onPressed: _retry,
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          side: BorderSide(color: context.accentColor),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: Text(
                          'Retry',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: context.accentColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (!snapshot.hasData) {
                return const Padding(
                  padding: EdgeInsets.only(top: 60),
                  child: AppLoader(),
                );
              }

              final tasks = _todayTasks(snapshot.data!);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),

                  HomeHeader(
                    notificationCount: _todayPendingCount(tasks),
                    onBellTap: () => Navigator.pushNamed(
                      context,
                      AppRoutes.notificationsScreen,
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

  List<TaskModel> _todayTasks(List<TaskModel> tasks) {
    final todayTasks = tasks.where(_isToday).toList();
    todayTasks.sort((a, b) {
      final dateCompare = a.date.compareTo(b.date);
      if (dateCompare != 0) return dateCompare;
      return a.timeMinutes.compareTo(b.timeMinutes);
    });
    return todayTasks;
  }

  bool _isToday(TaskModel task) {
    final now = DateTime.now();
    final date = task.date;
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}