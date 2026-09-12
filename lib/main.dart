import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'data/providers.dart';

void main() {
  runApp(
    ProviderScope(
      child: Consumer(
        builder: (context, ref, _) {
          final taskRepository = ref.read(taskRepositoryProvider);
          Future(() async {
            // Missed-occurrence sweep runs on app open (DATA_MODEL.md).
            await taskRepository.sweepMissed();
            await taskRepository.topUpAllOccurrences(now: DateTime.now());
          });
          return const StudyPlannerApp();
        },
      ),
    ),
  );
}
