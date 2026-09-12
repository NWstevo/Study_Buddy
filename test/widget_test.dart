import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:study_planner/app.dart';

void main() {
  testWidgets('app boots to a MaterialApp', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: StudyPlannerApp()),
    );
    expect(find.byType(MaterialApp), findsOneWidget);

    // Drift's stream-query cancellation schedules a zero-duration Timer
    // during disposal; unmount and flush it here so it doesn't fire after
    // the test body returns (flutter_test's strict pending-timer check).
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(Duration.zero);
  });
}
