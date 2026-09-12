import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_icons.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

enum TaskRowMetadataKind { deadline, alarmSet }

/// Task row per DESIGN_TOKENS.md § "Task row": time column, divider, title +
/// status/metadata line, trailing circular checkbox.
class TaskRow extends StatelessWidget {
  const TaskRow({
    super.key,
    required this.time,
    required this.title,
    required this.completed,
    this.metadataText,
    this.metadataKind = TaskRowMetadataKind.alarmSet,
    this.highlighted = false,
    this.onToggleComplete,
    this.checkboxKey,
  });

  final DateTime time;
  final String title;
  final bool completed;
  final String? metadataText;
  final TaskRowMetadataKind metadataKind;

  /// Accent-soft emphasis for the next upcoming pending task today
  /// (Main.dc.html shows one row in this style — interpreted as "up next").
  final bool highlighted;
  final VoidCallback? onToggleComplete;
  final Key? checkboxKey;

  (String, String) _timeParts() {
    final hour12 = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final hh = hour12.toString().padLeft(2, '0');
    final mm = time.minute.toString().padLeft(2, '0');
    return ('$hh:$mm', time.hour < 12 ? 'AM' : 'PM');
  }

  @override
  Widget build(BuildContext context) {
    final (hm, meridiem) = _timeParts();
    final background = completed
        ? AppColors.surface
        : (highlighted ? AppColors.accentSoft : AppColors.surface);
    final borderColor = completed
        ? AppColors.border
        : (highlighted ? AppColors.accent.withValues(alpha: 0.35) : AppColors.border);
    final dividerColor = highlighted && !completed
        ? AppColors.accent.withValues(alpha: 0.35)
        : AppColors.border;

    return Opacity(
      opacity: completed ? 0.55 : 1,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.cardPadding,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: background,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 44,
              child: Column(
                children: [
                  Text(
                    hm,
                    style: AppTextStyles.bodyStrong.copyWith(
                      fontSize: 13,
                      decoration: completed
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  Text(
                    meridiem,
                    style: AppTextStyles.metadata.copyWith(fontSize: 10),
                  ),
                ],
              ),
            ),
            Container(width: 1, height: 30, color: dividerColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyStrong.copyWith(
                      fontSize: 14,
                      decoration: completed
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  const SizedBox(height: 2),
                  if (completed)
                    Text(
                      'Completed',
                      style: AppTextStyles.metadata.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  else if (metadataText != null)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppIcons.path(
                          metadataKind == TaskRowMetadataKind.deadline
                              ? AppIcons.deadlineFlag
                              : AppIcons.alarmClock,
                          color: metadataKind == TaskRowMetadataKind.deadline
                              ? AppColors.danger
                              : AppColors.accent,
                          size: 12,
                          strokeWidth: 2,
                          includeCircle:
                              metadataKind == TaskRowMetadataKind.alarmSet,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          metadataText!,
                          style: AppTextStyles.metadata.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: metadataKind == TaskRowMetadataKind.deadline
                                ? AppColors.danger
                                : AppColors.accent,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _CompleteCheckbox(
              key: checkboxKey,
              completed: completed,
              accentBorder: highlighted,
              onTap: onToggleComplete,
            ),
          ],
        ),
      ),
    );
  }
}

class _CompleteCheckbox extends StatelessWidget {
  const _CompleteCheckbox({
    super.key,
    required this.completed,
    required this.accentBorder,
    required this.onTap,
  });

  final bool completed;
  final bool accentBorder;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final checkbox = Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: completed ? AppColors.success : null,
        border: completed
            ? null
            : Border.all(
                color: accentBorder ? AppColors.accent : AppColors.border,
                width: 1.75,
              ),
      ),
      child: completed
          ? AppIcons.path(
              AppIcons.checkmark,
              color: AppColors.surface,
              size: 14,
              strokeWidth: 2.5,
            )
          : null,
    );

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      // 44x44 minimum tap target (DESIGN_TOKENS.md/M6 accessibility) even
      // though the visible circle is 26x26.
      child: SizedBox(
        width: AppSpacing.minTapTarget,
        height: AppSpacing.minTapTarget,
        child: Center(child: checkbox),
      ),
    );
  }
}
