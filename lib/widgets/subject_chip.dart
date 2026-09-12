import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_icons.dart';
import '../theme/app_text_styles.dart';
import 'subject_tag_dot.dart';

/// Subject chip per DESIGN_TOKENS.md § "Subject chip": color dot + name,
/// selected = colored border + soft tint bg, unselected = neutral border +
/// white bg.
class SubjectChip extends StatelessWidget {
  const SubjectChip({
    super.key,
    required this.name,
    required this.colorHue,
    required this.selected,
    required this.onTap,
  });

  final String name;
  final int colorHue;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = AppColors.subjectPalette(colorHue);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? palette.soft : AppColors.surface,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected ? palette.dot : AppColors.border,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SubjectTagDot(colorHue: colorHue, size: 7),
            const SizedBox(width: 6),
            Text(
              name,
              style: AppTextStyles.bodyStrong.copyWith(
                fontSize: 13,
                color: selected ? palette.textOnTint : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The dashed "+ New" chip that opens inline subject creation.
class NewSubjectChip extends StatelessWidget {
  const NewSubjectChip({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          // The mockup uses a dashed border here; Flutter's BoxDecoration
          // has no dashed style short of a custom painter, so this uses a
          // solid one as a close approximation.
          border: Border.all(color: AppColors.textTertiary, width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIcons.path(AppIcons.plus, color: AppColors.textSecondary, size: 13, strokeWidth: 2.25),
            const SizedBox(width: 4),
            Text(
              'New',
              style: AppTextStyles.bodyStrong.copyWith(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
