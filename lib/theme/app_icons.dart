import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// The app's inline-SVG icon set, transcribed from the stroke-based icons in
/// design/*.dc.html (thin stroke, rounded caps — deliberately not Material
/// icons, per DESIGN_TOKENS.md § Icons).
class AppIcons {
  const AppIcons._();

  static const chevronLeft = 'M15 18l-6-6 6-6';
  static const chevronRight = 'M9 6l6 6-6 6';
  static const plus = 'M12 5v14M5 12h14';
  static const checkmark = 'M20 6L9 17l-5-5';
  static const deadlineFlag = 'M4 22V4M4 4h13l-2.5 4L17 12H4';
  static const mic = 'M5 10a7 7 0 0 0 14 0M12 21v-4';
  static const close = 'M18 6L6 18M6 6l12 12';

  static const calendarWeek = 'M3 9h18M8 2v4M16 2v4';
  static const subjectsBook =
      'M4 19.5A2.5 2.5 0 0 1 6.5 17H20 M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z';
  static const summaryChart = 'M3 3v18h18 M7 15l4-5 3 3 5-7';
  static const settingsGear =
      'M19.4 13.5a1.7 1.7 0 0 0 .34 1.87l.06.06a2.06 2.06 0 1 1-2.92 2.92l-.06-.06a1.7 1.7 0 0 0-1.87-.34 1.7 1.7 0 0 0-1.03 1.56V19.6a2.06 2.06 0 1 1-4.12 0v-.09a1.7 1.7 0 0 0-1.11-1.56 1.7 1.7 0 0 0-1.87.34l-.06.06a2.06 2.06 0 1 1-2.92-2.92l.06-.06a1.7 1.7 0 0 0 .34-1.87A1.7 1.7 0 0 0 2.6 12.4H2.5a2.06 2.06 0 1 1 0-4.12h.09a1.7 1.7 0 0 0 1.56-1.11 1.7 1.7 0 0 0-.34-1.87l-.06-.06a2.06 2.06 0 1 1 2.92-2.92l.06.06a1.7 1.7 0 0 0 1.87.34H8.6A1.7 1.7 0 0 0 9.6 1.28V.5a2.06 2.06 0 1 1 4.12 0v.09a1.7 1.7 0 0 0 1.03 1.56 1.7 1.7 0 0 0 1.87-.34l.06-.06a2.06 2.06 0 1 1 2.92 2.92l-.06.06a1.7 1.7 0 0 0-.34 1.87V6.6a1.7 1.7 0 0 0 1.56 1.03h.09a2.06 2.06 0 1 1 0 4.12h-.09a1.7 1.7 0 0 0-1.56 1.03z';

  static const clockHistory = 'M12 8v4l2.5 2.5';
  static const alarmClock = 'M12 8v4l3 2';

  /// A single-path stroke icon on a 24x24 viewBox, matching the mockups'
  /// stroke-width/cap/join conventions.
  static Widget path(
    String d, {
    required Color color,
    double size = 22,
    double strokeWidth = 1.75,
    bool includeCircle = false,
    double circleRadius = 9,
  }) {
    final circle = includeCircle
        ? '<circle cx="12" cy="12" r="$circleRadius"/>'
        : '';
    final svg =
        '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" '
        'viewBox="0 0 24 24" fill="none" stroke="${_toHex(color)}" '
        'stroke-width="$strokeWidth" stroke-linecap="round" '
        'stroke-linejoin="round">$circle<path d="$d"/></svg>';
    return SvgPicture.string(svg, width: size, height: size);
  }

  /// The mic icon is a capsule (rect) plus an arc+stem path — needs its own
  /// builder since [path] only supports a single path (with an optional
  /// circle for alarm-clock-style icons).
  static Widget micIcon({required Color color, double size = 15}) {
    final hex = _toHex(color);
    final svg =
        '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" '
        'viewBox="0 0 24 24" fill="none" stroke="$hex" stroke-width="2" '
        'stroke-linecap="round" stroke-linejoin="round">'
        '<rect x="9" y="2" width="6" height="12" rx="3"/>'
        '<path d="$mic"/></svg>';
    return SvgPicture.string(svg, width: size, height: size);
  }

  static String _toHex(Color color) {
    final value = color.toARGB32() & 0xFFFFFF;
    return '#${value.toRadixString(16).padLeft(6, '0')}';
  }
}
