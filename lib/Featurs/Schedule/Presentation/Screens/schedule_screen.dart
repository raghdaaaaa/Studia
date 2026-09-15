import 'package:flutter/material.dart';
import 'package:studia/Featurs/Add_Task/Data/Models/task_model.dart';
import 'package:studia/Featurs/Add_Task/Data/Services/task_service.dart';
import 'package:studia/Featurs/Focus%20Mode/Presentation/Screens/focus_mode_screen.dart';
import 'package:studia/Featurs/Schedule/Presentation/Screens/edit_task_screen.dart';
import 'package:studia/Featurs/Schedule/Presentation/Widgets/day_selector.dart';
import '../../../../Core/Constants/app_color.dart';
import '../../../../Core/Constants/app_strings.dart';
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
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w800,
                              fontSize: 30,
                              color: AppColors.primaryColor,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Search...',
                              hintStyle: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w800,
                                fontSize: 30,
                                color: AppColors.textSecondary,
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
                          child: const Icon(
                            Icons.close,
                            color: AppColors.primaryColor,
                            size: 26,
                          ),
                        ),
                      ],
                    )
                  : Row(
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
                          onTap: () {
                            setState(() => _searchActive = true);
                          },
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
                        color: AppColors.textSecondary,
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
    final bgColor = task.category == 'high'
        ? AppColors.primaryCardColor
        : task.category == 'medium'
            ? AppColors.primaryCard10Color
            : AppColors.backgroundColor;

    final showBorder = task.category == 'low';

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: GestureDetector(
        onTap: () {},
        onLongPress: () => _showTaskActions(context, taskService, task),
        child: TaskCard(
          title: task.title,
          isCompleted: task.isCompleted,
          showCompletionControl: true,
          onCompletionChanged: () {
            taskService.updateTaskCompletion(
              taskId: task.id,
              isCompleted: !task.isCompleted,
            );
          },
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
      await taskService.deleteTask(task.id);
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