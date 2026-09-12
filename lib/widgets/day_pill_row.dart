import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// One day's data for [DayPillRow]'s single-select "which day am I viewing"
/// mode (Main.dc.html). See DESIGN_TOKENS.md § "Day-of-week pill row" — the
/// same visual component is reused with multi-select semantics in
/// TaskSetup's recurrence picker (a separate widget, since the selection
/// model differs).
class DayPillData {
  const DayPillData({required this.date, this.indicatorColor});

  final DateTime date;

  /// The dot shown beneath the day number when it has at least one task —
  /// null means no dot (no tasks that day).
  final Color? indicatorColor;
}

class DayPillRow extends StatelessWidget {
  const DayPillRow({
    super.key,
    required this.days,
    required this.selectedDate,
    required this.onSelect,
  });

  final List<DayPillData> days;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onSelect;

  static const _weekdayLetters = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (final day in days)
          _DayPill(
            letter: _weekdayLetters[day.date.weekday - 1],
            dayNumber: day.date.day,
            indicatorColor: day.indicatorColor,
            selected: _isSameDay(day.date, selectedDate),
            onTap: () => onSelect(day.date),
          ),
      ],
    );
  }
}

class _DayPill extends StatelessWidget {
  const _DayPill({
    required this.letter,
    required this.dayNumber,
    required this.indicatorColor,
    required this.selected,
    required this.onTap,
  });

  final String letter;
  final int dayNumber;
  final Color? indicatorColor;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final labelColor = selected ? AppColors.accent : AppColors.textTertiary;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Semantics(
        selected: selected,
        button: true,
        label: 'Day $dayNumber',
        child: SizedBox(
          width: 44,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                letter,
                style: AppTextStyles.metadata.copyWith(
                  color: labelColor,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected ? AppColors.accent : null,
                ),
                child: Text(
                  '$dayNumber',
                  style: AppTextStyles.body.copyWith(
                    fontSize: 13,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                    color: selected
                        ? AppColors.surface
                        : AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: indicatorColor ?? const Color(0x00000000),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
