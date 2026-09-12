import 'weekday.dart';

enum Frequency { once, weekly }

/// Time-of-day the alarm fires on each active day, independent of any
/// specific date (see DATA_MODEL.md § TaskDefinition.alarmTime).
class AlarmTimeOfDay {
  const AlarmTimeOfDay({required this.hour, required this.minute})
    : assert(hour >= 0 && hour < 24),
      assert(minute >= 0 && minute < 60);

  final int hour;
  final int minute;

  /// Minutes since midnight — used as the compact storage representation.
  int get minutesSinceMidnight => hour * 60 + minute;

  static AlarmTimeOfDay fromMinutesSinceMidnight(int minutes) {
    return AlarmTimeOfDay(hour: minutes ~/ 60, minute: minutes % 60);
  }

  DateTime onDate(DateTime date) {
    return DateTime(date.year, date.month, date.day, hour, minute);
  }

  @override
  String toString() =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
}

/// The template for a task/routine — what the user edits on the "New Task"
/// screen. See DATA_MODEL.md § TaskDefinition.
class TaskDefinition {
  TaskDefinition({
    required this.id,
    required this.subjectId,
    required this.title,
    this.notes,
    required this.frequency,
    Set<Weekday> weekdays = const {},
    this.oneTimeDate,
    required this.alarmTime,
    this.deadline,
    required this.createdAt,
    this.archivedAt,
  }) : weekdays = Set.unmodifiable(weekdays) {
    if (frequency == Frequency.weekly && this.weekdays.isEmpty) {
      throw ArgumentError(
        'A weekly TaskDefinition must select at least one weekday.',
      );
    }
    if (frequency == Frequency.once && oneTimeDate == null) {
      throw ArgumentError(
        'A once TaskDefinition must specify oneTimeDate.',
      );
    }
  }

  final String id;
  final String subjectId;
  final String title;
  final String? notes;
  final Frequency frequency;

  /// Only meaningful when `frequency == Frequency.weekly`. Never empty for a
  /// weekly task — enforced in the constructor per DATA_MODEL.md.
  final Set<Weekday> weekdays;

  /// The single occurrence's date when `frequency == Frequency.once`.
  ///
  /// Not named in DATA_MODEL.md — that doc defines `weekdays` for the
  /// weekly case but doesn't say how a one-time task's date is captured.
  /// CONTEXT.md's flow step 1 implies it ("which days it repeats on (or a
  /// one-time occurrence)"), so this field fills that gap; flagged here
  /// rather than silently assumed in case the intended shape differs.
  final DateTime? oneTimeDate;
  final AlarmTimeOfDay alarmTime;

  /// Independent of [alarmTime] — see CONTEXT.md: the deadline is when the
  /// obligation is actually due, which may be later than any individual
  /// alarm occurrence.
  final DateTime? deadline;
  final DateTime createdAt;
  final DateTime? archivedAt;

  bool get isArchived => archivedAt != null;

  TaskDefinition copyWith({
    String? title,
    String? notes,
    bool clearNotes = false,
    Frequency? frequency,
    Set<Weekday>? weekdays,
    DateTime? oneTimeDate,
    AlarmTimeOfDay? alarmTime,
    DateTime? deadline,
    bool clearDeadline = false,
    DateTime? archivedAt,
    bool clearArchivedAt = false,
  }) {
    return TaskDefinition(
      id: id,
      subjectId: subjectId,
      title: title ?? this.title,
      notes: clearNotes ? null : (notes ?? this.notes),
      frequency: frequency ?? this.frequency,
      weekdays: weekdays ?? this.weekdays,
      oneTimeDate: oneTimeDate ?? this.oneTimeDate,
      alarmTime: alarmTime ?? this.alarmTime,
      deadline: clearDeadline ? null : (deadline ?? this.deadline),
      createdAt: createdAt,
      archivedAt: clearArchivedAt ? null : (archivedAt ?? this.archivedAt),
    );
  }
}
