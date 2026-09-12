import 'package:flutter/material.dart';

import '../models/weekday.dart';
import '../theme/app_colors.dart';

/// Multi-select day-of-week pill row for TaskSetup's recurrence picker — the
/// same visual component as [DayPillRow] (DESIGN_TOKENS.md § "Day-of-week
/// pill row") but with multi-select semantics ("which days does this
/// repeat") instead of single-select ("which day am I viewing").
class WeekdayMultiSelectRow extends StatelessWidget {
  const WeekdayMultiSelectRow({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final Set<Weekday> selected;
  final ValueChanged<Set<Weekday>> onChanged;

  static const _letters = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (final day in Weekday.values)
          _Pill(
            letter: _letters[day.index],
            isSelected: selected.contains(day),
            onTap: () {
              final next = Set<Weekday>.from(selected);
              if (!next.remove(day)) next.add(day);
              onChanged(next);
            },
          ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.letter, required this.isSelected, required this.onTap});

  final String letter;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? AppColors.accent : null,
          border: isSelected ? null : Border.all(color: AppColors.border, width: 1.5),
        ),
        child: Text(
          letter,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            color: isSelected ? AppColors.surface : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
