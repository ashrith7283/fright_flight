import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'mute_button.dart';
import 'vibration_button.dart';

/// Sound and vibration toggles grouped in one row.
class SettingsToggles extends StatelessWidget {
  const SettingsToggles({
    super.key,
    required this.muted,
    required this.onToggleMute,
    required this.vibration,
    required this.onToggleVibration,
  });

  final ValueListenable<bool> muted;
  final VoidCallback onToggleMute;
  final ValueListenable<bool> vibration;
  final VoidCallback onToggleVibration;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        MuteButton(muted: muted, onToggle: onToggleMute),
        const SizedBox(width: 10),
        VibrationButton(vibration: vibration, onToggle: onToggleVibration),
      ],
    );
  }
}
