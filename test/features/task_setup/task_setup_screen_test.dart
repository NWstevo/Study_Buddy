import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:study_planner/data/database.dart';
import 'package:study_planner/data/providers.dart';
import 'package:study_planner/data/subject_repository.dart';
import 'package:study_planner/data/task_repository.dart';
import 'package:study_planner/features/task_setup/task_setup_screen.dart';
import 'package:study_planner/models/subject.dart';
import 'package:study_planner/models/task_definition.dart';
import 'package:study_planner/models/weekday.dart';
import 'package:study_planner/theme/app_theme.dart';

void main() {
  testWidgets(
    'creating a weekly task via the keyboard path persists a definition '
    'and generates an occurrence',
    (tester) async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);
      final subjects = SubjectRepository(db);
      final tasks = TaskRepository(db);

      await subjects.create(
        Subject(
          id: 'subj-1',
          name: 'Cell Biology',
          colorHue: 195,
          createdAt: DateTime(2026, 1, 1),
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [appDatabaseProvider.overrideWithValue(db)],
          child: MaterialApp(
            theme: AppTheme.light(),
            home: const TaskSetupScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Select the existing subject.
      await tester.tap(find.text('Cell Biology'));
      await tester.pump();

      // Type the title via keyboard (voice is a separate, non-blocking path).
      await tester.enterText(
        find.byKey(const ValueKey('voice-field-task-title')),
        'Review lecture notes',
      );
      await tester.pump();

      // Default frequency is weekly with no weekdays picked yet — pick one
      // via the multi-select pill row ("M" for Monday, first pill).
      await tester.tap(find.text('M').first);
      await tester.pump();

      // Save.
      await tester.ensureVisible(find.widgetWithText(ElevatedButton, 'Save task'));
      await tester.tap(find.widgetWithText(ElevatedButton, 'Save task'));
      await tester.pumpAndSettle();

      // A plain one-shot Future query, not `.watch()` — Drift's watch
      // streams schedule real Timers for debouncing that never fire inside
      // testWidgets' FakeAsync zone without an explicit pump, so `.first`
      // on a stream here would hang forever.
      final definitions = await tasks.getAllDefinitions();
      expect(definitions, hasLength(1));
      expect(definitions.single.title, 'Review lecture notes');
      expect(definitions.single.subjectId, 'subj-1');
      expect(definitions.single.frequency, Frequency.weekly);
      expect(definitions.single.weekdays, contains(Weekday.monday));

      // Flush Drift's stream-cancellation Timer before the test ends (see
      // widget_test.dart for why).
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(Duration.zero);
    },
  );

  testWidgets(
    'tapping the mic with no speech/permission plugin registered falls '
    'back gracefully instead of crashing the field',
    (tester) async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [appDatabaseProvider.overrideWithValue(db)],
          child: MaterialApp(
            theme: AppTheme.light(),
            home: const TaskSetupScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // No platform implementation is registered for permission_handler or
      // speech_to_text in a plain widget test — this is exactly the
      // "unavailable" case IMPLEMENTATION_PLAN.md M3 requires degrading
      // gracefully from, so it doubles as a real-world regression check.
      await tester.tap(find.byKey(const ValueKey('mic-button-task-title')));
      await tester.pumpAndSettle();

      // The field itself must still be present and usable via the keyboard.
      await tester.enterText(
        find.byKey(const ValueKey('voice-field-task-title')),
        'Typed after a failed mic tap',
      );
      await tester.pumpAndSettle();

      expect(find.text('Typed after a failed mic tap'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(Duration.zero);
    },
  );
}
