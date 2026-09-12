import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'data/providers.dart';
import 'debug/seed_data.dart';

void main() {
  runApp(
    ProviderScope(
      child: Consumer(
        builder: (context, ref, _) {
          final taskRepository = ref.read(taskRepositoryProvider);
          Future(() async {
            // Debug-only: until M3 ships the "New Task" screen, there's no
            // way to create data to look at. Remove once M3 lands.
            if (kDebugMode) {
              await seedDebugDataIfEmpty(
                subjectRepository: ref.read(subjectRepositoryProvider),
                taskRepository: taskRepository,
              );
            }
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
