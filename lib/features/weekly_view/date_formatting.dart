const _monthNames = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

/// "Mon 8 — Sun 14 Sep" — the week-range label in Main.dc.html's header.
/// [weekStart] must be the Monday of the week.
String formatWeekRange(DateTime weekStart) {
  final weekEnd = weekStart.add(const Duration(days: 6));
  final sameMonth = weekStart.month == weekEnd.month;
  final endLabel = sameMonth
      ? 'Sun ${weekEnd.day} ${_monthNames[weekEnd.month - 1]}'
      : 'Sun ${weekEnd.day} ${_monthNames[weekEnd.month - 1]}';
  return 'Mon ${weekStart.day} — $endLabel';
}

/// "Due today" / "Due tomorrow" / "Due Sep 12" for a deadline relative to
/// [now]'s date.
String formatDeadline(DateTime deadline, DateTime now) {
  final today = DateTime(now.year, now.month, now.day);
  final due = DateTime(deadline.year, deadline.month, deadline.day);
  final daysUntil = due.difference(today).inDays;
  if (daysUntil == 0) return 'Due today';
  if (daysUntil == 1) return 'Due tomorrow';
  if (daysUntil == -1) return 'Due yesterday';
  if (daysUntil < 0) return 'Overdue — ${_monthNames[due.month - 1]} ${due.day}';
  return 'Due ${_monthNames[due.month - 1]} ${due.day}';
}
