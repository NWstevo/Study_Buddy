import 'package:flutter/widgets.dart';

import '../theme/app_colors.dart';

/// Small colored dot marking a subject, per DESIGN_TOKENS.md § Subject chip.
class SubjectTagDot extends StatelessWidget {
  const SubjectTagDot({super.key, required this.colorHue, this.size = 8});

  final int colorHue;
  final double size;

  @override
  Widget build(BuildContext context) {
    final palette = AppColors.subjectPalette(colorHue);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: palette.dot, shape: BoxShape.circle),
    );
  }
}
