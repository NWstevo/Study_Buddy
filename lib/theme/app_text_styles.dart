import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Typography from DESIGN_TOKENS.md § Typography.
///
/// Bricolage Grotesque for display/headings, Public Sans for body/UI — this
/// pairing is a deliberate identity choice, never substitute Inter/Roboto
/// or the system default.
class AppTextStyles {
  const AppTextStyles._();

  static TextStyle _display({
    required double fontSize,
    required FontWeight fontWeight,
    Color? color,
  }) {
    return GoogleFonts.bricolageGrotesque(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color ?? AppColors.textPrimary,
    );
  }

  static TextStyle _body({
    required double fontSize,
    required FontWeight fontWeight,
    Color? color,
  }) {
    return GoogleFonts.publicSans(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color ?? AppColors.textPrimary,
    );
  }

  // Display / headings (Bricolage Grotesque)
  static TextStyle screenTitle = _display(fontSize: 26, fontWeight: FontWeight.w800);
  static TextStyle sectionTitle = _display(fontSize: 20, fontWeight: FontWeight.w700);
  static TextStyle completionPercentage = _display(fontSize: 44, fontWeight: FontWeight.w800);
  static TextStyle alarmTaskName = _display(
    fontSize: 26,
    fontWeight: FontWeight.w700,
    color: AppColors.alarmTextPrimary,
  );

  // Body / UI (Public Sans)
  static TextStyle body = _body(fontSize: 15, fontWeight: FontWeight.w400);
  static TextStyle bodyStrong = _body(fontSize: 15, fontWeight: FontWeight.w600);
  static TextStyle label = _body(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );
  static TextStyle metadata = _body(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );
  static TextStyle button = _body(fontSize: 15, fontWeight: FontWeight.w700);
}
