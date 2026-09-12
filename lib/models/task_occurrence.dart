enum OccurrenceStatus { pending, completed, missed, carriedForward }

/// A single concrete instance of a task on a specific date — what the
/// weekly view, the alarm, and the summary all operate on. See
/// DATA_MODEL.md § TaskOccurrence and § "Occurrence status state machine".
class TaskOccurrence {
  const TaskOccurrence({
    required this.id,
    required this.taskDefinitionId,
    required this.subjectId,
    required this.scheduledDate,
    required this.alarmAt,
    this.deadline,
    this.status = OccurrenceStatus.pending,
    this.completedAt,
    this.carriedFromOccurrenceId,
    this.carryCount = 0,
  });

  final String id;
  final String taskDefinitionId;

  /// Denormalized copy of the parent's subjectId, taken at generation time so
  /// historical reports stay correct even if the task is reassigned later.
  final String subjectId;

  /// The day this occurrence is "for."
  final DateTime scheduledDate;

  /// Date + time the alarm fires. Starts as `scheduledDate + parent.alarmTime`;
  /// changes on reschedule or carry-forward. Never left null — see
  /// DATA_MODEL.md's "never leave a carried/rescheduled task without a
  /// concrete new alarmAt" invariant.
  final DateTime alarmAt;
  final DateTime? deadline;
  final OccurrenceStatus status;
  final DateTime? completedAt;

  /// Set when this occurrence was created *by* carrying another one forward —
  /// links the chain so history is traceable.
  final String? carriedFromOccurrenceId;

  /// How many times this thread has been carried forward.
  final int carryCount;

  TaskOccurrence copyWith({
    DateTime? scheduledDate,
    DateTime? alarmAt,
    DateTime? deadline,
    bool clearDeadline = false,
    OccurrenceStatus? status,
    DateTime? completedAt,
    bool clearCompletedAt = false,
    int? carryCount,
  }) {
    return TaskOccurrence(
      id: id,
      taskDefinitionId: taskDefinitionId,
      subjectId: subjectId,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      alarmAt: alarmAt ?? this.alarmAt,
      deadline: clearDeadline ? null : (deadline ?? this.deadline),
      status: status ?? this.status,
      completedAt: clearCompletedAt
          ? null
          : (completedAt ?? this.completedAt),
      carriedFromOccurrenceId: carriedFromOccurrenceId,
      carryCount: carryCount ?? this.carryCount,
    );
  }
}
