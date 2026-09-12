import 'dart:math' as math;
import 'package:flutter/widgets.dart';

/// Converts an OKLCH color (as authored in DESIGN_TOKENS.md) to a Flutter
/// [Color]. Flutter's Color API has no native OKLCH constructor, so per
/// DESIGN_TOKENS.md's guidance we compute directly from the OKLCH values
/// instead of relying on hand-copied hex approximations, which the doc
/// notes "may drift slightly" from the authored color.
///
/// Implements the standard OKLab <-> linear sRGB matrices (Björn Ottosson,
/// https://bottosson.github.io/posts/oklab/).
Color oklch({required double l, required double c, required double h}) {
  final hRad = h * math.pi / 180;
  final a = c * math.cos(hRad);
  final b = c * math.sin(hRad);

  final lNonlinear = l + 0.3963377774 * a + 0.2158037573 * b;
  final mNonlinear = l - 0.1055613458 * a - 0.0638541728 * b;
  final sNonlinear = l - 0.0894841775 * a - 1.2914855480 * b;

  final lCubed = lNonlinear * lNonlinear * lNonlinear;
  final mCubed = mNonlinear * mNonlinear * mNonlinear;
  final sCubed = sNonlinear * sNonlinear * sNonlinear;

  final rLinear =
      4.0767416621 * lCubed - 3.3077115913 * mCubed + 0.2309699292 * sCubed;
  final gLinear =
      -1.2684380046 * lCubed + 2.6097574011 * mCubed - 0.3413193965 * sCubed;
  final bLinear =
      -0.0041960863 * lCubed - 0.7034186147 * mCubed + 1.7076147010 * sCubed;

  return Color.fromARGB(
    255,
    _toSrgbByte(rLinear),
    _toSrgbByte(gLinear),
    _toSrgbByte(bLinear),
  );
}

int _toSrgbByte(double linear) {
  final clampedLinear = linear.clamp(0.0, 1.0);
  final encoded = clampedLinear <= 0.0031308
      ? 12.92 * clampedLinear
      : 1.055 * math.pow(clampedLinear, 1 / 2.4) - 0.055;
  return (encoded.clamp(0.0, 1.0) * 255).round();
}
