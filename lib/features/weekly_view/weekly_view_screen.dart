import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../../models/subject.dart';
import '../../models/task_definition.dart';
import '../../models/task_occurrence.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_icons.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_bottom_nav.dart';
import '../../widgets/day_pill_row.dart';
import '../../widgets/subject_tag_dot.dart';
import '../../widgets/task_row.dart';
import '../task_setup/task_setup_screen.dart';
import 'date_formatting.dart';
import 'weekly_view_providers.dart';

class WeeklyViewScreen extends ConsumerWidget {
  const WeeklyViewScreen({super.key});

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selection = ref.watch(weeklyViewControllerProvider);
    final controller = ref.read(weeklyViewControllerProvider.notifier);

    final subjects = ref.watch(activeSubjectsProvider).value;
    final definitions = ref.watch(allTaskDefinitionsProvider).value;
    final occurrences = ref
        .watch(weekOccurrencesProvider(selection.weekStart))
        .value;

    final ready = subjects != null && definitions != null && occurrences != null;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _Header(
              weekStart: selection.weekStart,
              onPreviousWeek: controller.goToPreviousWeek,
              onNextWeek: controller.goToNextWeek,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPaddingHorizontal,
                4,
                AppSpacing.screenPaddingHorizontal,
                18,
              ),
              child: DayPillRow(
                days: [
                  for (var i = 0; i < 7; i++)
                    _dayPillFor(
                      selection.weekStart.add(Duration(days: i)),
                      occurrences ?? const [],
                      subjects ?? const [],
                    ),
                ],
                selectedDate: selection.selectedDate,
                onSelect: controller.selectDate,
              ),
            ),
            Expanded(
              child: !ready
                  ? const Center(child: CircularProgressIndicator())
                  : _TaskList(
                      selectedDate: selection.selectedDate,
                      subjects: subjects,
                      definitions: definitions,
                      occurrences: occurrences,
                    ),
            ),
            AppBottomNav(
              currentTab: AppTab.week,
              onTabSelected: (_) {},
              onFabPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const TaskSetupScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  DayPillData _dayPillFor(
    DateTime date,
    List<TaskOccurrence> weekOccurrences,
    List<Subject> subjects,
  ) {
    final onThisDay = weekOccurrences
        .where((o) => _isSameDay(o.scheduledDate, date))
        .toList()
      ..sort((a, b) => a.alarmAt.compareTo(b.alarmAt));
    if (onThisDay.isEmpty) return DayPillData(date: date);

    final subjectId = onThisDay.first.subjectId;
    Subject? subject;
    for (final s in subjects) {
      if (s.id == subjectId) {
        subject = s;
        break;
      }
    }
    if (subject == null) return DayPillData(date: date);
    return DayPillData(
      date: date,
      indicatorColor: AppColors.subjectPalette(subject.colorHue).dot,
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.weekStart,
    required this.onPreviousWeek,
    required this.onNextWeek,
  });

  final DateTime weekStart;
  final VoidCallback onPreviousWeek;
  final VoidCallback onNextWeek;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPaddingHorizontal,
        8,
        AppSpacing.screenPaddingHorizontal,
        16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('This Week', style: AppTextStyles.screenTitle),
              SizedBox(
                width: AppSpacing.minTapTarget,
                height: AppSpacing.minTapTarget,
                child: Center(
                  child: AppIcons.path(
                    AppIcons.clockHistory,
                    color: AppColors.textSecondary,
                    includeCircle: true,
                    circleRadius: 8.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _RoundIconButton(
                icon: AppIcons.chevronLeft,
                onTap: onPreviousWeek,
              ),
              Text(formatWeekRange(weekStart), style: AppTextStyles.label),
              _RoundIconButton(
                icon: AppIcons.chevronRight,
                onTap: onNextWeek,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({required this.icon, required this.onTap});

  final String icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.surface,
          border: Border.all(color: AppColors.border),
        ),
        child: AppIcons.path(icon, color: AppColors.textSecondary, size: 16, strokeWidth: 2),
      ),
    );
  }
}

class _TaskList extends ConsumerWidget {
  const _TaskList({
    required this.selectedDate,
    required this.subjects,
    required this.definitions,
    required this.occurrences,
  });

  final DateTime selectedDate;
  final List<Subject> subjects;
  final List<TaskDefinition> definitions;
  final List<TaskOccurrence> occurrences;

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final isToday = _isSameDay(selectedDate, today);

    final todaysOccurrences = occurrences
        .where((o) => _isSameDay(o.scheduledDate, selectedDate))
        .toList();

    if (todaysOccurrences.isEmpty) {
      return Center(
        child: Text('Nothing scheduled for this day.', style: AppTextStyles.label),
      );
    }

    // "Up next" highlight: the earliest still-pending task today whose
    // alarm hasn't fired yet (Main.dc.html shows one row emphasized).
    String? nextUpId;
    if (isToday) {
      final upcoming = todaysOccurrences
          .where((o) => o.status == OccurrenceStatus.pending && o.alarmAt.isAfter(now))
          .toList()
        ..sort((a, b) => a.alarmAt.compareTo(b.alarmAt));
      if (upcoming.isNotEmpty) nextUpId = upcoming.first.id;
    }

    final bySubject = <String, List<TaskOccurrence>>{};
    for (final occurrence in todaysOccurrences) {
      (bySubject[occurrence.subjectId] ??= []).add(occurrence);
    }

    final orderedSubjects = subjects.where((s) => bySubject.containsKey(s.id)).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPaddingHorizontal,
        4,
        AppSpacing.screenPaddingHorizontal,
        20,
      ),
      children: [
        for (final subject in orderedSubjects) ...[
          _SubjectGroup(
            subject: subject,
            occurrences: bySubject[subject.id]!..sort((a, b) => a.alarmAt.compareTo(b.alarmAt)),
            definitions: definitions,
            now: now,
            nextUpId: nextUpId,
            onToggleComplete: (occurrenceId) =>
                ref.read(taskRepositoryProvider).markCompleted(occurrenceId),
          ),
          const SizedBox(height: 22),
        ],
      ],
    );
  }
}

class _SubjectGroup extends StatelessWidget {
  const _SubjectGroup({
    required this.subject,
    required this.occurrences,
    required this.definitions,
    required this.now,
    required this.nextUpId,
    required this.onToggleComplete,
  });

  final Subject subject;
  final List<TaskOccurrence> occurrences;
  final List<TaskDefinition> definitions;
  final DateTime now;
  final String? nextUpId;
  final ValueChanged<String> onToggleComplete;

  String _titleFor(String taskDefinitionId) {
    for (final definition in definitions) {
      if (definition.id == taskDefinitionId) return definition.title;
    }
    return 'Untitled task';
  }

  @override
  Widget build(BuildContext context) {
    final count = occurrences.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SubjectTagDot(colorHue: subject.colorHue),
            const SizedBox(width: 8),
            Text(
              subject.name,
              style: AppTextStyles.bodyStrong.copyWith(fontSize: 13),
            ),
            const SizedBox(width: 6),
            Text(
              count == 1 ? '1 task' : '$count tasks',
              style: AppTextStyles.metadata,
            ),
          ],
        ),
        const SizedBox(height: 10),
        for (final occurrence in occurrences) ...[
          TaskRow(
            key: ValueKey('task-row-${occurrence.id}'),
            checkboxKey: ValueKey('task-checkbox-${occurrence.id}'),
            time: occurrence.alarmAt,
            title: _titleFor(occurrence.taskDefinitionId),
            completed: occurrence.status == OccurrenceStatus.completed,
            highlighted: occurrence.id == nextUpId,
            metadataKind: occurrence.deadline != null
                ? TaskRowMetadataKind.deadline
                : TaskRowMetadataKind.alarmSet,
            metadataText: occurrence.deadline != null
                ? formatDeadline(occurrence.deadline!, now)
                : 'Alarm set for ${occurrence.alarmAt.hour.toString().padLeft(2, '0')}:${occurrence.alarmAt.minute.toString().padLeft(2, '0')}',
            onToggleComplete: occurrence.status == OccurrenceStatus.completed
                ? null
                : () => onToggleComplete(occurrence.id),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}
