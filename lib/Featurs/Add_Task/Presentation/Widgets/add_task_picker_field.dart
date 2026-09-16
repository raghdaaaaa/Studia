import 'package:flutter/material.dart';
import '../../../../Core/Constants/app_color.dart';
import '../../../../Core/Theme/app_palette.dart';

enum PickerType { date, time }

class AddTaskPickerField extends StatefulWidget {
  final String label;
  final String iconAsset;
  final PickerType type;
  final DateTime? initialDate;
  final TimeOfDay? initialTime;
  final void Function(DateTime)?   onDatePicked;
  final void Function(TimeOfDay)?  onTimePicked;

  const AddTaskPickerField({
    super.key,
    required this.label,
    required this.iconAsset,
    required this.type,
    this.initialDate,
    this.initialTime,
    this.onDatePicked,
    this.onTimePicked,
  });

  @override
  State<AddTaskPickerField> createState() => _AddTaskPickerFieldState();
}

class _AddTaskPickerFieldState extends State<AddTaskPickerField> {
  late DateTime _date = widget.initialDate ?? DateTime.now();
  late TimeOfDay _time =
      widget.initialTime ?? const TimeOfDay(hour: 10, minute: 0);

  Future<void> _pick() async {
    if (widget.type == PickerType.date) {
      final picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2020),
        lastDate: DateTime(2030),
        builder: (context, child) => _themedPicker(child!),
      );
      if (picked != null) {
        setState(() => _date = picked);
        widget.onDatePicked?.call(picked);
      }
    } else {
      final picked = await showTimePicker(
        context: context,
        initialTime: _time,
        builder: (context, child) => _themedPicker(child!),
      );
      if (picked != null) {
        setState(() => _time = picked);
        widget.onTimePicked?.call(picked);
      }
    }
  }

  Widget _themedPicker(Widget child) {
    final isDark = context.isDarkMode;
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: isDark
            ? const ColorScheme.dark(
                primary: AppColors.primaryCardColor,
                onPrimary: AppColors.primaryColor,
                surface: AppColors.darkSurface,
                onSurface: AppColors.darkTextPrimary,
              )
            : const ColorScheme.light(
                primary: AppColors.primaryColor,
                onPrimary: AppColors.white,
                surface: AppColors.white,
                onSurface: AppColors.primaryColor,
              ),
      ),
      child: child,
    );
  }

  String get _displayValue {
    if (widget.type == PickerType.date) {
      const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
      return '${months[_date.month - 1]} ${_date.day}, ${_date.year}';
    } else {
      final hour   = _time.hourOfPeriod == 0 ? 12 : _time.hourOfPeriod;
      final minute = _time.minute.toString().padLeft(2, '0');
      final period = _time.period == DayPeriod.am ? 'AM' : 'PM';
      return '$hour:$minute $period';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 17,
            color: context.accentColor,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pick,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
            decoration: BoxDecoration(
              color: context.surfaceColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    _displayValue,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      color: context.accentColor,
                    ),
                  ),
                ),
                Image.asset(widget.iconAsset, width: 18, height: 18),
              ],
            ),
          ),
        ),
      ],
    );
  }
}