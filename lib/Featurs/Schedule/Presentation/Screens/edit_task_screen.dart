import 'package:flutter/material.dart';
import 'package:studia/Featurs/Add_Task/Data/Models/task_model.dart';
import 'package:studia/Featurs/Add_Task/Data/Services/task_service.dart';
import 'package:studia/Featurs/Add_Task/Presentation/Widgets/add_task_picker_field.dart';
import 'package:studia/Featurs/Add_Task/Presentation/Widgets/add_text_.dart';

import '../../../../Core/Constants/app_color.dart';
import '../../../../Core/Constants/app_strings.dart';
import '../../../../Core/Constants/assets.dart';
import '../../../../Core/Theme/app_palette.dart';
import '../../../../Core/Widgets/app_scaffold.dart';
import '../../../../Core/Widgets/primary_button.dart';
import '../../../Add_Task/Presentation/Widgets/category_chip.dart';

class EditTaskScreen extends StatefulWidget {
  final TaskModel task;

  const EditTaskScreen({super.key, required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late final TextEditingController _titleController =
      TextEditingController(text: widget.task.title);
  late final TextEditingController _descriptionController =
      TextEditingController(text: widget.task.description);

  final TaskService _taskService = TaskService();

  late String _category = widget.task.category;
  late DateTime _selectedDate = widget.task.date;
  late TimeOfDay _selectedTime = _parseTime(widget.task.time);

  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  TimeOfDay _parseTime(String time) {
    final match = RegExp(
      r'^(\d{1,2}):(\d{2})\s*(AM|PM)$',
    ).firstMatch(time.trim());

    if (match == null) {
      return const TimeOfDay(hour: 10, minute: 0);
    }

    var hour = int.parse(match.group(1)!);
    final minute = int.parse(match.group(2)!);
    final period = match.group(3);

    if (period == 'PM' && hour != 12) hour += 12;
    if (period == 'AM' && hour == 12) hour = 0;

    return TimeOfDay(hour: hour, minute: minute);
  }

  Future<void> _updateTask() async {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter task name.'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final formattedTime = _formatTime(_selectedTime);

    try {
      await _taskService.updateTask(
        taskId: widget.task.id,
        title: title,
        description: description,
        category: _category,
        date: _selectedDate,
        time: formattedTime,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppStrings.editTaskUpdatedSuccess,
            style: TextStyle(color: context.accentColor),
          ),
          backgroundColor: AppColors.primaryCardColor,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${AppStrings.editTaskUpdatedError}$e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';

    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentNavIndex: 1,
      showFab: false,
      showBottomNav: false,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: context.accentColor,
                  size: 22,
                ),
              ),
              const SizedBox(height: 16),

              Text(
                AppStrings.editTaskTitle,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w800,
                  fontSize: 30,
                  color: context.accentColor,
                ),
              ),
              const SizedBox(height: 24),

              Text(
                AppStrings.addTaskNameLabel,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: context.accentColor,
                ),
              ),
              const SizedBox(height: 8),

              AppTextField(
                hint: AppStrings.addTaskNameHint,
                controller: _titleController,
              ),

              const SizedBox(height: 35),

              Text(
                AppStrings.addTaskCategoryLabel,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: context.accentColor,
                ),
              ),
              const SizedBox(height: 8),

              CategoryChipRow(
                initialCategory: _category,
                onChanged: (priority) {
                  _category = priority;
                },
              ),

              const SizedBox(height: 50),

              Row(
                children: [
                  Expanded(
                    child: AddTaskPickerField(
                      label: AppStrings.addTaskDateLabel,
                      iconAsset: AppAssets.date,
                      type: PickerType.date,
                      initialDate: _selectedDate,
                      onDatePicked: (date) {
                        _selectedDate = date;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AddTaskPickerField(
                      label: AppStrings.addTaskTimeLabel,
                      iconAsset: AppAssets.time,
                      type: PickerType.time,
                      initialTime: _selectedTime,
                      onTimePicked: (time) {
                        _selectedTime = time;
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              Text(
                AppStrings.addTaskDescriptionLabel,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: context.accentColor,
                ),
              ),
              const SizedBox(height: 8),

              AppTextField(
                hint: AppStrings.addTaskDescriptionHint,
                maxLines: 5,
                controller: _descriptionController,
              ),

              const SizedBox(height: 32),

              PrimaryButton(
                label: _isLoading
                    ? AppStrings.editTaskUpdating
                    : AppStrings.editTaskSaveButton,
                height: 80,
                onPressed: _isLoading ? () {} : _updateTask,
              ),

              const SizedBox(height: 200),
            ],
          ),
        ),
      ),
    );
  }
}