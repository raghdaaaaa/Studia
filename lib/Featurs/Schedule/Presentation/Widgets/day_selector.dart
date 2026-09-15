import 'package:flutter/material.dart';
import '../../../../Core/Constants/app_color.dart';

class DaySelector extends StatefulWidget {
  const DaySelector({super.key});

  @override
  State<DaySelector> createState() => _DaySelectorState();
}

class _DaySelectorState extends State<DaySelector> {
  int _selectedIndex = 1;

  late final List<_DayItem> _days = _buildDays();

  List<_DayItem> _buildDays() {
    final today = DateTime.now();
    final start = today.subtract(const Duration(days: 1));
    return List.generate(4, (i) {
      final date = start.add(Duration(days: i));
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

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _days.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        final isSelected = index == _selectedIndex;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index < _days.length - 1 ? 10 : 0),
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedIndex = index);
              },
              child: AnimatedContainer(
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
          ),
        );
      }).toList(),
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