import 'package:flutter/material.dart';

import 'features/weekly_view/weekly_view_screen.dart';
import 'theme/app_theme.dart';

class StudyPlannerApp extends StatelessWidget {
  const StudyPlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Study Planner',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const WeeklyViewScreen(),
    );
  }
}
