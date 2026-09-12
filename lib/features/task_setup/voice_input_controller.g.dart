// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voice_input_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Owns the single [SpeechToText] instance shared by every voice-enabled
/// text field (CONTEXT.md: voice-to-text is required on every input field,
/// so this is a cross-cutting service, not per-field state) — only one
/// field can be dictating at a time anyway, since there's one microphone.
///
/// Per IMPLEMENTATION_PLAN.md M3: a denied mic permission or an unavailable
/// speech recognizer must never block the field — callers fall back to
/// plain keyboard input when [startListening] doesn't return `started`.

@ProviderFor(VoiceInputController)
final voiceInputControllerProvider = VoiceInputControllerProvider._();

/// Owns the single [SpeechToText] instance shared by every voice-enabled
/// text field (CONTEXT.md: voice-to-text is required on every input field,
/// so this is a cross-cutting service, not per-field state) — only one
/// field can be dictating at a time anyway, since there's one microphone.
///
/// Per IMPLEMENTATION_PLAN.md M3: a denied mic permission or an unavailable
/// speech recognizer must never block the field — callers fall back to
/// plain keyboard input when [startListening] doesn't return `started`.
final class VoiceInputControllerProvider
    extends $NotifierProvider<VoiceInputController, String?> {
  /// Owns the single [SpeechToText] instance shared by every voice-enabled
  /// text field (CONTEXT.md: voice-to-text is required on every input field,
  /// so this is a cross-cutting service, not per-field state) — only one
  /// field can be dictating at a time anyway, since there's one microphone.
  ///
  /// Per IMPLEMENTATION_PLAN.md M3: a denied mic permission or an unavailable
  /// speech recognizer must never block the field — callers fall back to
  /// plain keyboard input when [startListening] doesn't return `started`.
  VoiceInputControllerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'voiceInputControllerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$voiceInputControllerHash();

  @$internal
  @override
  VoiceInputController create() => VoiceInputController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$voiceInputControllerHash() =>
    r'2d616480b3a9f510ef9e52941d7adf5177996c0f';

/// Owns the single [SpeechToText] instance shared by every voice-enabled
/// text field (CONTEXT.md: voice-to-text is required on every input field,
/// so this is a cross-cutting service, not per-field state) — only one
/// field can be dictating at a time anyway, since there's one microphone.
///
/// Per IMPLEMENTATION_PLAN.md M3: a denied mic permission or an unavailable
/// speech recognizer must never block the field — callers fall back to
/// plain keyboard input when [startListening] doesn't return `started`.

abstract class _$VoiceInputController extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<String?, String?>, String?, Object?, Object?>;
    return element.handleCreate(ref, build);
  }
}
