import 'package:flutter/material.dart';
import 'package:studia/Featurs/Add_Task/Data/Services/task_service.dart';
import 'package:studia/Featurs/Add_Task/Presentation/Widgets/add_task_picker_field.dart';
import 'package:studia/Featurs/Add_Task/Presentation/Widgets/add_text_.dart';

import '../../../../Core/Constants/app_color.dart';
import '../../../../Core/Constants/app_strings.dart';
import '../../../../Core/Constants/assets.dart';
import '../../../../Core/Widgets/app_scaffold.dart';
import '../../../../Core/Widgets/primary_button.dart';
import '../widgets/category_chip.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController =
      TextEditingController();

  final TaskService _taskService = TaskService();

  String _category = 'medium';
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = const TimeOfDay(hour: 10, minute: 0);

  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _createTask() async {
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
      await _taskService.createTask(
        title: title,
        description: description,
        category: _category,
        date: _selectedDate,
        time: formattedTime,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Task created successfully.'),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not create task: $e'),
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
      currentNavIndex: 2,
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
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: AppColors.primaryColor,
                  size: 22,
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                AppStrings.addTaskTitle,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w800,
                  fontSize: 30,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                AppStrings.addTaskNameLabel,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 8),

              AppTextField(
                hint: AppStrings.addTaskNameHint,
                controller: _titleController,
              ),

              const SizedBox(height: 35),

              const Text(
                AppStrings.addTaskCategoryLabel,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 8),

              CategoryChipRow(
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
                      onTimePicked: (time) {
                        _selectedTime = time;
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              const Text(
                AppStrings.addTaskDescriptionLabel,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: AppColors.primaryColor,
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
                    ? 'Creating...'
                    : AppStrings.addTaskCreateButton,
                height: 80,
                onPressed: _isLoading ? () {} : _createTask,
              ),

              const SizedBox(height: 200),
            ],
          ),
        ),
      ),
    );
  }
}