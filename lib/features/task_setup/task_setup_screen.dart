import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../data/providers.dart';
import '../../models/subject.dart';
import '../../models/task_definition.dart';
import '../../models/weekday.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_icons.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/subject_chip.dart';
import '../../widgets/voice_text_field.dart';
import '../../widgets/weekday_multi_select_row.dart';
import '../weekly_view/weekly_view_providers.dart';

const _monthNames = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

String _formatShortDate(DateTime date) => '${_monthNames[date.month - 1]} ${date.day}';

String _formatTimeOfDay(TimeOfDay time) {
  final hour12 = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
  final hh = hour12.toString().padLeft(2, '0');
  final mm = time.minute.toString().padLeft(2, '0');
  final period = time.period == DayPeriod.am ? 'AM' : 'PM';
  return '$hh:$mm $period';
}

class TaskSetupScreen extends ConsumerStatefulWidget {
  const TaskSetupScreen({super.key});

  @override
  ConsumerState<TaskSetupScreen> createState() => _TaskSetupScreenState();
}

class _TaskSetupScreenState extends ConsumerState<TaskSetupScreen> {
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();

  String? _selectedSubjectId;
  Frequency _frequency = Frequency.weekly;
  Set<Weekday> _weekdays = {};
  DateTime? _oneTimeDate;
  TimeOfDay _alarmTime = const TimeOfDay(hour: 8, minute: 0);
  DateTime? _deadline;
  bool _saving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickOneTimeDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _oneTimeDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (picked != null) setState(() => _oneTimeDate = picked);
  }

  Future<void> _pickDeadline() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _deadline ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (picked != null) setState(() => _deadline = picked);
  }

  Future<void> _pickAlarmTime() async {
    final picked = await showTimePicker(context: context, initialTime: _alarmTime);
    if (picked != null) setState(() => _alarmTime = picked);
  }

  Future<void> _createSubject(List<Subject> existing) async {
    final controller = TextEditingController();
    final name = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusCard)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.screenPaddingHorizontal,
            right: AppSpacing.screenPaddingHorizontal,
            top: 20,
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('New subject', style: AppTextStyles.sectionTitle),
              const SizedBox(height: 16),
              VoiceTextField(
                fieldId: 'new-subject-name',
                label: 'Subject name',
                controller: controller,
                hintText: 'e.g. Organic Chemistry',
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.of(sheetContext).pop(controller.text.trim()),
                child: const Text('Add subject'),
              ),
            ],
          ),
        );
      },
    );
    controller.dispose();
    if (name == null || name.isEmpty) return;

    final hue = AppColors.subjectHues[existing.length % AppColors.subjectHues.length];
    final subject = Subject(
      id: const Uuid().v4(),
      name: name,
      colorHue: hue,
      createdAt: DateTime.now(),
    );
    await ref.read(subjectRepositoryProvider).create(subject);
    if (mounted) setState(() => _selectedSubjectId = subject.id);
  }

  bool get _canSave {
    if (_selectedSubjectId == null) return false;
    if (_titleController.text.trim().isEmpty) return false;
    if (_frequency == Frequency.weekly && _weekdays.isEmpty) return false;
    if (_frequency == Frequency.once && _oneTimeDate == null) return false;
    return true;
  }

  Future<void> _save() async {
    if (!_canSave || _saving) return;
    setState(() => _saving = true);
    final now = DateTime.now();
    final definition = TaskDefinition(
      id: const Uuid().v4(),
      subjectId: _selectedSubjectId!,
      title: _titleController.text.trim(),
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      frequency: _frequency,
      weekdays: _frequency == Frequency.weekly ? _weekdays : const {},
      oneTimeDate: _frequency == Frequency.once ? _oneTimeDate : null,
      alarmTime: AlarmTimeOfDay(hour: _alarmTime.hour, minute: _alarmTime.minute),
      deadline: _deadline,
      createdAt: now,
    );
    await ref.read(taskRepositoryProvider).createDefinition(definition);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final subjects = ref.watch(activeSubjectsProvider).value ?? const <Subject>[];

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _Header(onBack: () => Navigator.of(context).maybePop()),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenPaddingHorizontal,
                  4,
                  AppSpacing.screenPaddingHorizontal,
                  20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Subject', style: AppTextStyles.label),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final subject in subjects)
                          SubjectChip(
                            name: subject.name,
                            colorHue: subject.colorHue,
                            selected: subject.id == _selectedSubjectId,
                            onTap: () => setState(() => _selectedSubjectId = subject.id),
                          ),
                        NewSubjectChip(onTap: () => _createSubject(subjects)),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sectionGap),

                    VoiceTextField(
                      fieldId: 'task-title',
                      label: 'Task or routine name',
                      controller: _titleController,
                      hintText: 'e.g. Practice set — integrals',
                      helperText: 'Tap the mic to speak instead of typing',
                    ),
                    const SizedBox(height: AppSpacing.sectionGap),

                    Text('Frequency', style: AppTextStyles.label),
                    const SizedBox(height: 8),
                    _FrequencyToggle(
                      value: _frequency,
                      onChanged: (f) => setState(() => _frequency = f),
                    ),
                    const SizedBox(height: AppSpacing.sectionGap),

                    if (_frequency == Frequency.weekly) ...[
                      Text('Repeats on', style: AppTextStyles.label),
                      const SizedBox(height: 8),
                      WeekdayMultiSelectRow(
                        selected: _weekdays,
                        onChanged: (days) => setState(() => _weekdays = days),
                      ),
                    ] else ...[
                      Text('Date', style: AppTextStyles.label),
                      const SizedBox(height: 8),
                      _PickerField(
                        icon: AppIcons.deadlineFlag,
                        iconColor: AppColors.danger,
                        value: _oneTimeDate == null
                            ? 'Select a date'
                            : _formatShortDate(_oneTimeDate!),
                        onTap: _pickOneTimeDate,
                      ),
                    ],
                    const SizedBox(height: AppSpacing.sectionGap),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Alarm time', style: AppTextStyles.label),
                              const SizedBox(height: 8),
                              _PickerField(
                                icon: AppIcons.alarmClock,
                                includeCircle: true,
                                iconColor: AppColors.textSecondary,
                                value: _formatTimeOfDay(_alarmTime),
                                onTap: _pickAlarmTime,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Deadline (optional)', style: AppTextStyles.label),
                              const SizedBox(height: 8),
                              _PickerField(
                                icon: AppIcons.deadlineFlag,
                                iconColor: AppColors.danger,
                                value: _deadline == null ? 'None' : _formatShortDate(_deadline!),
                                onTap: _pickDeadline,
                                onClear: _deadline == null ? null : () => setState(() => _deadline = null),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sectionGap),

                    VoiceTextField(
                      fieldId: 'task-notes',
                      label: 'Notes',
                      controller: _notesController,
                      hintText: 'Optional details',
                      minLines: 3,
                      maxLines: 5,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 22),
              child: ElevatedButton(
                onPressed: _canSave && !_saving ? _save : null,
                child: Text(_saving ? 'Saving…' : 'Save task'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPaddingHorizontal,
        8,
        AppSpacing.screenPaddingHorizontal,
        6,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surface,
                border: Border.all(color: AppColors.border),
              ),
              child: AppIcons.path(
                AppIcons.chevronLeft,
                color: AppColors.textPrimary,
                size: 18,
                strokeWidth: 2,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Text('New Task', style: AppTextStyles.sectionTitle),
        ],
      ),
    );
  }
}

class _FrequencyToggle extends StatelessWidget {
  const _FrequencyToggle({required this.value, required this.onChanged});

  final Frequency value;
  final ValueChanged<Frequency> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.border.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ToggleOption(
              label: 'One-time',
              selected: value == Frequency.once,
              onTap: () => onChanged(Frequency.once),
            ),
          ),
          Expanded(
            child: _ToggleOption(
              label: 'Weekly routine',
              selected: value == Frequency.weekly,
              onTap: () => onChanged(Frequency.weekly),
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleOption extends StatelessWidget {
  const _ToggleOption({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          color: selected ? AppColors.surface : null,
          borderRadius: BorderRadius.circular(9),
          boxShadow: selected
              ? [BoxShadow(color: AppColors.textPrimary.withValues(alpha: 0.08), blurRadius: 3)]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTextStyles.bodyStrong.copyWith(
            fontSize: 13,
            color: selected ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _PickerField extends StatelessWidget {
  const _PickerField({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.onTap,
    this.includeCircle = false,
    this.onClear,
  });

  final String icon;
  final Color iconColor;
  final String value;
  final VoidCallback onTap;
  final bool includeCircle;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.border, width: 1.5),
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        ),
        child: Row(
          children: [
            AppIcons.path(icon, color: iconColor, size: 17, strokeWidth: 1.75, includeCircle: includeCircle),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                value,
                style: AppTextStyles.bodyStrong.copyWith(fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (onClear != null)
              GestureDetector(
                onTap: onClear,
                child: AppIcons.path(
                  AppIcons.close,
                  color: AppColors.textTertiary,
                  size: 14,
                  strokeWidth: 2,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
