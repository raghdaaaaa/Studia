import 'package:flutter/material.dart';
import 'package:studia/Featurs/Add_Task/Data/Models/task_model.dart';
import 'package:studia/Featurs/Add_Task/Data/Services/task_service.dart';
import 'package:studia/Featurs/Focus%20Mode/Presentation/Screens/focus_mode_screen.dart';
import 'package:studia/Featurs/Schedule/Presentation/Screens/edit_task_screen.dart';
import 'package:studia/Featurs/Schedule/Presentation/Widgets/day_selector.dart';
import '../../../../Core/Constants/app_color.dart';
import '../../../../Core/Constants/app_strings.dart';
import '../../../../Core/Constants/task_category.dart';
import '../../../../Core/Theme/app_palette.dart';
import '../../../../Core/Widgets/app_loader.dart';
import '../../../../Core/Widgets/app_scaffold.dart';
import '../../../../Core/Widgets/section_header.dart';
import '../../../../Core/Widgets/task_card.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  DateTime _selectedDate = DateTime.now();
  bool _searchActive = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

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
              _searchActive
                  ? Row(
                      children: [
                        Expanded(
                          child: TextField(
                            autofocus: true,
                            controller: _searchController,
                            onChanged: (value) {
                              setState(() => _searchQuery = value);
                            },
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w800,
                              fontSize: 30,
                              color: context.accentColor,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Search...',
                              hintStyle: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w800,
                                fontSize: 30,
                                color: context.textSecondaryColor,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _searchActive = false;
                              _searchQuery = '';
                              _searchController.clear();
                            });
                          },
                          child: Icon(
                            Icons.close,
                            color: context.accentColor,
                            size: 26,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppStrings.scheduleTitle,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w800,
                            fontSize: 30,
                            color: context.accentColor,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() => _searchActive = true);
                          },
                          child: Icon(
                            Icons.search,
                            color: context.accentColor,
                            size: 26,
                          ),
                        ),
                      ],
                    ),
              const SizedBox(height: 30),

              // Day Selector
              DaySelector(
                selectedDate: _selectedDate,
                onDaySelected: (date) {
                  setState(() => _selectedDate = date);
                },
              ),
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
                        color: context.textSecondaryColor,
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
                  var visibleTasks = tasks
                      .where((task) => _isSameDay(task.date, _selectedDate))
                      .toList();

                  if (_searchActive && _searchQuery.isNotEmpty) {
                    final query = _searchQuery.toLowerCase();
                    visibleTasks = visibleTasks
                        .where((task) =>
                            task.title.toLowerCase().contains(query))
                        .toList();
                  }

                  if (visibleTasks.isEmpty) {
                    return Text(
                      'No tasks yet. Tap + to add your first task.',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: context.textSecondaryColor,
                      ),
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final task in visibleTasks)
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
    final bgColor = TaskCategory.background(
      task.category,
      isDark: context.isDarkMode,
    );
    final showBorder = TaskCategory.showBorder(task.category);

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: GestureDetector(
        onTap: () {},
        onLongPress: () => _showTaskActions(context, taskService, task),
        child: TaskCard(
          title: task.title,
          isCompleted: task.isCompleted,
          showCompletionControl: true,
          onCompletionChanged: () => _toggleCompletion(
            context,
            taskService,
            task,
          ),
          backgroundColor: bgColor,
          border: showBorder
              ? Border.all(
                  color: TaskCategory.border(
                    task.category,
                    isDark: context.isDarkMode,
                  ),
                  width: 1.5,
                )
              : null,
          timeRange: '${_formatDate(task.date)}  •  ${task.time}',
          teamLabel: TaskCategory.label(task.category),
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

  Future<void> _toggleCompletion(
    BuildContext context,
    TaskService taskService,
    TaskModel task,
  ) async {
    try {
      await taskService.updateTaskCompletion(
        taskId: task.id,
        isCompleted: !task.isCompleted,
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not update task: $e')),
      );
    }
  }

  Future<void> _showTaskActions(
    BuildContext context,
    TaskService taskService,
    TaskModel task,
  ) async {
    final action = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Task'),
        content: Text('"${task.title}"'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'edit'),
            child: const Text('Edit'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'delete'),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (!mounted) return;

    if (action == 'edit') {
      Navigator.push(
        this.context,
        MaterialPageRoute(builder: (_) => EditTaskScreen(task: task)),
      );
    } else if (action == 'delete') {
      final confirmed = await showDialog<bool>(
        context: this.context,
        builder: (context) => AlertDialog(
          backgroundColor: context.isDarkMode
              ? AppColors.darkCard
              : AppColors.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Delete task?',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
              color: context.accentColor,
            ),
          ),
          content: Text(
            '"${task.title}" will be permanently removed.',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: context.textSecondaryColor,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'Cancel',
                style: TextStyle(color: context.textSecondaryColor),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Delete',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
            ),
          ],
        ),
      );

      if (confirmed != true || !mounted) return;

      try {
        await taskService.deleteTask(task.id);
        if (!mounted) return;
        ScaffoldMessenger.of(this.context).showSnackBar(
          const SnackBar(content: Text('Task deleted')),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(this.context).showSnackBar(
          SnackBar(content: Text('Could not delete task: $e')),
        );
      }
    }
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