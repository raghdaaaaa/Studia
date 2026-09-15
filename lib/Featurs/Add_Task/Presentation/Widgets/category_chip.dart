import 'package:flutter/material.dart';
import '../../../../Core/Constants/app_color.dart';
import '../../../../Core/Constants/app_strings.dart';

class CategoryChipRow extends StatefulWidget {
  const CategoryChipRow({super.key, this.onChanged});
  final void Function(String)? onChanged;

  @override
  State<CategoryChipRow> createState() => _CategoryChipRowState();
}

class _CategoryChipRowState extends State<CategoryChipRow> {
  String _selected = AppStrings.addTaskDesign;

  final List<String> _categories = [
    AppStrings.addTaskDesign,
    AppStrings.addTaskDevelopment,
    AppStrings.addTaskStudy,
  ];

   String _toPriority(String category) {
    if (category == AppStrings.addTaskDevelopment) return 'high';
    if (category == AppStrings.addTaskDesign)      return 'medium';
    return 'low';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _categories.asMap().entries.map((entry) {
          final index      = entry.key;
          final label      = entry.value;
          final isSelected = _selected == label;

          return Padding(
            padding: EdgeInsets.only(left: index == 0 ? 0 : 10),
            child: GestureDetector(
              onTap: () {
                setState(() => _selected = label);
                 widget.onChanged?.call(_toPriority(label));
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 13),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryColor : AppColors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    width: 2,
                    color: isSelected
                        ? AppColors.primaryColor
                        : AppColors.textSecondary,
                  ),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: isSelected ? AppColors.white : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}