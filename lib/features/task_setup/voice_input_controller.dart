import 'package:flutter/foundation.dart' show ValueSetter;
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

part 'voice_input_controller.g.dart';

enum VoiceInputStartResult { started, permissionDenied, unavailable }

/// Owns the single [SpeechToText] instance shared by every voice-enabled
/// text field (CONTEXT.md: voice-to-text is required on every input field,
/// so this is a cross-cutting service, not per-field state) — only one
/// field can be dictating at a time anyway, since there's one microphone.
///
/// Per IMPLEMENTATION_PLAN.md M3: a denied mic permission or an unavailable
/// speech recognizer must never block the field — callers fall back to
/// plain keyboard input when [startListening] doesn't return `started`.
@riverpod
class VoiceInputController extends _$VoiceInputController {
  final SpeechToText _speech = SpeechToText();
  bool? _available;

  /// The id of the field currently listening, or null if none is.
  @override
  String? build() {
    ref.onDispose(() {
      try {
        if (_speech.isListening) _speech.stop();
      } catch (_) {
        // Disposal is not the place to surface a plugin error.
      }
    });
    return null;
  }

  // A missing/misbehaving platform plugin (no microphone hardware, a
  // sandboxed/test environment, an OEM quirk) must degrade to "unavailable,
  // keep typing" — never crash the field. Every platform-channel call in
  // this class is deliberately wrapped for that reason.
  Future<bool> _ensureReady() async {
    if (_available != null) return _available!;

    try {
      final statuses = await [Permission.microphone, Permission.speech].request();
      final permissionGranted = statuses.values.every(
        (status) => status.isGranted || status.isLimited,
      );
      if (!permissionGranted) {
        _available = false;
        return false;
      }

      _available = await _speech.initialize(
        onStatus: (status) {
          if (status == 'notListening' || status == 'done') {
            state = null;
          }
        },
        onError: (_) => state = null,
      );
    } catch (_) {
      _available = false;
    }
    return _available!;
  }

  Future<bool> _isPermanentlyDenied() async {
    try {
      return await Permission.microphone.isPermanentlyDenied;
    } catch (_) {
      return false;
    }
  }

  Future<VoiceInputStartResult> startListening({
    required String fieldId,
    required ValueSetter<String> onResult,
  }) async {
    if (state != null) await stopListening();

    final ready = await _ensureReady();
    if (!ready) {
      return await _isPermanentlyDenied()
          ? VoiceInputStartResult.permissionDenied
          : VoiceInputStartResult.unavailable;
    }

    try {
      state = fieldId;
      await _speech.listen(
        onResult: (SpeechRecognitionResult result) => onResult(result.recognizedWords),
        listenOptions: SpeechListenOptions(
          partialResults: true,
          cancelOnError: true,
          pauseFor: const Duration(seconds: 3),
          listenFor: const Duration(seconds: 30),
        ),
      );
      return VoiceInputStartResult.started;
    } catch (_) {
      state = null;
      return VoiceInputStartResult.unavailable;
    }
  }

  Future<void> stopListening() async {
    try {
      if (_speech.isListening) await _speech.stop();
    } catch (_) {
      // Best-effort — the state reset below is what actually matters.
    }
    state = null;
  }

  bool isListeningTo(String fieldId) => state == fieldId;
}
