import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:study_planner/data/database.dart';
import 'package:study_planner/data/providers.dart';
import 'package:study_planner/data/subject_repository.dart';
import 'package:study_planner/data/task_repository.dart';
import 'package:study_planner/features/weekly_view/weekly_view_screen.dart';
import 'package:study_planner/models/subject.dart';
import 'package:study_planner/models/task_definition.dart';
import 'package:study_planner/models/weekday.dart';
import 'package:study_planner/theme/app_theme.dart';

void main() {
  testWidgets(
    'shows today\'s task grouped by subject and completes it on tap',
    (tester) async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);
      final subjects = SubjectRepository(db);
      final tasks = TaskRepository(db);

      final today = DateTime.now();
      final todayDateOnly = DateTime(today.year, today.month, today.day);

      await subjects.create(
        Subject(
          id: 'subj-1',
          name: 'Cell Biology',
          colorHue: 195,
          createdAt: DateTime(2026, 1, 1),
        ),
      );
      await tasks.createDefinition(
        TaskDefinition(
          id: 'def-1',
          subjectId: 'subj-1',
          title: 'Review lecture notes',
          frequency: Frequency.weekly,
          weekdays: {Weekday.fromDateTime(todayDateOnly)},
          alarmTime: const AlarmTimeOfDay(hour: 19, minute: 0),
          createdAt: DateTime(2026, 1, 1),
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [appDatabaseProvider.overrideWithValue(db)],
          child: MaterialApp(
            theme: AppTheme.light(),
            home: const WeeklyViewScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('This Week'), findsOneWidget);
      expect(find.text('Cell Biology'), findsOneWidget);
      expect(find.text('Review lecture notes'), findsOneWidget);
      expect(find.text('Completed'), findsNothing);

      final occurrences = await tasks.occurrencesInRange(
        todayDateOnly,
        todayDateOnly.add(const Duration(days: 1)),
      );
      final occurrenceId = occurrences.single.id;

      await tester.tap(find.byKey(ValueKey('task-checkbox-$occurrenceId')));
      await tester.pumpAndSettle();

      expect(find.text('Completed'), findsOneWidget);

      // Flush Drift's stream-cancellation Timer before the test ends (see
      // widget_test.dart for why).
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(Duration.zero);
    },
  );
}
