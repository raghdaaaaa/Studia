import 'package:flutter/material.dart';
import '../../../../Core/Constants/app_color.dart';

class DaySelector extends StatefulWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDaySelected;

  const DaySelector({
    super.key,
    required this.selectedDate,
    required this.onDaySelected,
  });

  @override
  State<DaySelector> createState() => _DaySelectorState();
}

class _DaySelectorState extends State<DaySelector> {
  late final List<_DayItem> _days = _buildDays();

  List<_DayItem> _buildDays() {
    final now = DateTime.now();
    final startOfWeek =
        DateTime(now.year, now.month, now.day - (now.weekday - 1));
    return List.generate(7, (i) {
      final date = startOfWeek.add(Duration(days: i));
      return _DayItem(
        day: _dayName(date.weekday),
        date: date.day.toString(),
        fullDate: date,
      );
    });
  }

  String _dayName(int weekday) {
    const names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return names[weekday - 1];
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _days.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isSelected = _isSameDay(item.fullDate, widget.selectedDate);

          return Padding(
            padding: EdgeInsets.only(right: index < _days.length - 1 ? 10 : 0),
            child: GestureDetector(
              onTap: () => widget.onDaySelected(item.fullDate),
              child: AnimatedContainer(
                width: 76,
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 21),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryColor : AppColors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(width: 1.5, color: AppColors.primaryColor),
                ),
                child: Column(
                  children: [
                    Text(
                      item.day,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? AppColors.white
                            : AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.date,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w800,
                        fontSize: 21,
                        color: isSelected
                            ? AppColors.white
                            : AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _DayItem {
  final String day;
  final String date;
  final DateTime fullDate;
  const _DayItem(
      {required this.day, required this.date, required this.fullDate});
}
