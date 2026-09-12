import 'dart:async';

import 'package:google_fonts/google_fonts.dart';

/// Runs before every test in this directory (Flutter's test runner picks
/// this up automatically). Without it, GoogleFonts.bricolageGrotesque()/
/// publicSans() try to fetch font files over HTTP on first use, which hangs
/// or is flaky in a sandboxed/offline test run — fall back to the bundled
/// default font instead.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  GoogleFonts.config.allowRuntimeFetching = false;
  await testMain();
}
