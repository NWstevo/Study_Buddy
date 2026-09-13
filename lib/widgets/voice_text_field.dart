import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/task_setup/voice_input_controller.dart';
import '../theme/app_colors.dart';
import '../theme/app_icons.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// The one text-entry component used everywhere in the app (title, notes,
/// and any field added later) — label above, bordered field, right-aligned
/// mic button. Per CONTEXT.md, every text field needs both a keyboard and a
/// mic affordance; per IMPLEMENTATION_PLAN.md M3, a denied permission or an
/// unavailable recognizer must never block typing.
class VoiceTextField extends ConsumerStatefulWidget {
  const VoiceTextField({
    super.key,
    required this.fieldId,
    required this.label,
    required this.controller,
    this.hintText,
    this.minLines = 1,
    this.maxLines = 1,
    this.helperText,
  });

  /// Unique per field on screen — lets [VoiceInputController] track which
  /// single field (of possibly several) is currently dictating.
  final String fieldId;
  final String label;
  final TextEditingController controller;
  final String? hintText;
  final int minLines;
  final int maxLines;
  final String? helperText;

  @override
  ConsumerState<VoiceTextField> createState() => _VoiceTextFieldState();
}

class _VoiceTextFieldState extends ConsumerState<VoiceTextField> {
  String _baseText = '';

  Future<void> _onMicTap() async {
    final controllerNotifier = ref.read(voiceInputControllerProvider.notifier);
    final alreadyListening = ref.read(voiceInputControllerProvider) == widget.fieldId;
    if (alreadyListening) {
      await controllerNotifier.stopListening();
      return;
    }

    _baseText = widget.controller.text.trim();
    final result = await controllerNotifier.startListening(
      fieldId: widget.fieldId,
      onResult: (spoken) {
        // The speech plugin's result callback can fire after this widget is
        // gone (e.g. the screen was popped mid-listen) — touching
        // widget.controller past disposal throws.
        if (!mounted) return;
        widget.controller.text = _baseText.isEmpty ? spoken : '$_baseText $spoken';
        widget.controller.selection = TextSelection.collapsed(
          offset: widget.controller.text.length,
        );
      },
    );
    if (!mounted) return;
    switch (result) {
      case VoiceInputStartResult.started:
        break;
      case VoiceInputStartResult.permissionDenied:
        _showFallback(
          "Microphone access is off, so you'll need to type instead. "
          'Turn it on in Settings to use voice input.',
        );
      case VoiceInputStartResult.unavailable:
        _showFallback("Voice input isn't available on this device — you can still type.");
    }
  }

  void _showFallback(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final listening = ref.watch(voiceInputControllerProvider) == widget.fieldId;
    final multiline = widget.maxLines > 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: AppTextStyles.label),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border.all(
              color: listening ? AppColors.accent : AppColors.border,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
          ),
          child: Row(
            crossAxisAlignment: multiline
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                  key: ValueKey('voice-field-${widget.fieldId}'),
                  controller: widget.controller,
                  minLines: widget.minLines,
                  maxLines: widget.maxLines,
                  style: AppTextStyles.body.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: AppTextStyles.body.copyWith(
                      fontSize: 15,
                      color: AppColors.textTertiary,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                key: ValueKey('mic-button-${widget.fieldId}'),
                onTap: _onMicTap,
                child: Container(
                  width: 30,
                  height: 30,
                  margin: multiline ? const EdgeInsets.only(top: 2) : null,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: listening ? AppColors.accent : AppColors.accentSoft,
                  ),
                  child: Center(
                    child: AppIcons.micIcon(
                      color: listening ? AppColors.surface : AppColors.accent,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (widget.helperText != null) ...[
          const SizedBox(height: 6),
          Text(
            listening ? 'Listening…' : widget.helperText!,
            style: AppTextStyles.metadata.copyWith(
              fontSize: 11,
              color: listening ? AppColors.accent : AppColors.textTertiary,
            ),
          ),
        ],
      ],
    );
  }
}
