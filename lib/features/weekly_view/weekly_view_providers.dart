import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/occurrence_rules.dart';
import '../../data/providers.dart';
import '../../models/subject.dart';
import '../../models/task_definition.dart';
import '../../models/task_occurrence.dart';

part 'weekly_view_providers.g.dart';

@riverpod
Stream<List<Subject>> activeSubjects(Ref ref) {
  return ref.watch(subjectRepositoryProvider).watchActive();
}

@riverpod
Stream<List<TaskDefinition>> allTaskDefinitions(Ref ref) {
  return ref.watch(taskRepositoryProvider).watchAllDefinitions();
}

/// Keyed by the Monday of the week to watch (normalized so the family cache
/// doesn't churn on time-of-day differences).
@riverpod
Stream<List<TaskOccurrence>> weekOccurrences(Ref ref, DateTime weekStart) {
  final normalized = OccurrenceRules.dateOnly(weekStart);
  return ref.watch(taskRepositoryProvider).watchOccurrencesForWeek(normalized);
}

/// Which week (by its Monday) and which specific day within it the weekly
/// view is showing.
class WeeklyViewSelection {
  const WeeklyViewSelection({required this.weekStart, required this.selectedDate});

  final DateTime weekStart;
  final DateTime selectedDate;

  int get selectedWeekdayIndex => selectedDate.weekday - 1;
}

@riverpod
class WeeklyViewController extends _$WeeklyViewController {
  @override
  WeeklyViewSelection build() {
    final today = OccurrenceRules.dateOnly(DateTime.now());
    return WeeklyViewSelection(
      weekStart: _startOfWeek(today),
      selectedDate: today,
    );
  }

  static DateTime _startOfWeek(DateTime day) {
    return day.subtract(Duration(days: day.weekday - 1));
  }

  void selectDate(DateTime date) {
    state = WeeklyViewSelection(
      weekStart: state.weekStart,
      selectedDate: OccurrenceRules.dateOnly(date),
    );
  }

  void goToNextWeek() => _shiftWeek(7);

  void goToPreviousWeek() => _shiftWeek(-7);

  void _shiftWeek(int days) {
    final newWeekStart = state.weekStart.add(Duration(days: days));
    final newSelectedDate = newWeekStart.add(
      Duration(days: state.selectedWeekdayIndex),
    );
    state = WeeklyViewSelection(
      weekStart: newWeekStart,
      selectedDate: newSelectedDate,
    );
  }
}
