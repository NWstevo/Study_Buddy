import 'package:flutter/widgets.dart';

import 'oklch_color.dart';

/// Colors from DESIGN_TOKENS.md, computed directly from the oklch() values
/// as authored (that doc's preferred path over its hex approximations,
/// which it notes "may drift slightly"). Every value here should trace back
/// to a line in DESIGN_TOKENS.md — don't hand-roll colors per screen.
class AppColors {
  const AppColors._();

  // Neutrals (warm, not pure gray)
  static final bg = oklch(l: 0.98, c: 0.012, h: 75);
  static final surface = oklch(l: 1, c: 0, h: 0);
  static final border = oklch(l: 0.89, c: 0.012, h: 75);
  static final textPrimary = oklch(l: 0.22, c: 0.014, h: 75);
  static final textSecondary = oklch(l: 0.48, c: 0.012, h: 75);
  static final textTertiary = oklch(l: 0.62, c: 0.01, h: 75);

  // Primary accent (violet)
  static final accent = oklch(l: 0.5, c: 0.15, h: 288);
  static final accentHover = oklch(l: 0.42, c: 0.15, h: 288);
  static final accentSoft = oklch(l: 0.94, c: 0.03, h: 288);

  // Status colors — semantic, never reused for subject tags
  static final success = oklch(l: 0.62, c: 0.14, h: 155);
  static final successSoft = oklch(l: 0.94, c: 0.045, h: 155);
  static final danger = oklch(l: 0.58, c: 0.17, h: 25);
  static final dangerSoft = oklch(l: 0.94, c: 0.045, h: 25);
  static final warning = oklch(l: 0.72, c: 0.14, h: 70);
  static final warningDark = oklch(l: 0.58, c: 0.12, h: 70);
  static final warningSoft = oklch(l: 0.94, c: 0.05, h: 70);

  // Alarm-screen dark variant (AlarmActive.dc.html)
  static final alarmBg = oklch(l: 0.24, c: 0.055, h: 288);
  static final alarmSurfaceRaised = oklch(l: 0.32, c: 0.06, h: 288);
  static final alarmSurfaceRaisedAlt = oklch(l: 0.28, c: 0.06, h: 288);
  static final alarmTextPrimary = oklch(l: 0.98, c: 0.01, h: 288);
  static final alarmTextSecondary = oklch(l: 0.78, c: 0.04, h: 288);

  /// Subject tag palette (DATA_MODEL.md `Subject.colorHue` picks one of
  /// these hues — never an arbitrary hex). Add more at the same
  /// chroma/lightness if a 5th+ subject is needed, staying clear of the
  /// status hues (155 success / 25 danger / 70 warning).
  static const subjectHues = <int>[240, 195, 320, 100];

  static SubjectPalette subjectPalette(int hue) {
    return SubjectPalette(
      dot: oklch(l: 0.62, c: 0.14, h: hue.toDouble()),
      soft: oklch(l: 0.94, c: 0.045, h: hue.toDouble()),
      textOnTint: oklch(l: 0.32, c: 0.09, h: hue.toDouble()),
    );
  }
}

class SubjectPalette {
  const SubjectPalette({
    required this.dot,
    required this.soft,
    required this.textOnTint,
  });

  final Color dot;
  final Color soft;
  final Color textOnTint;
}
