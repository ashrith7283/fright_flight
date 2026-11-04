import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'glass_icon_button.dart';

/// Vibration toggle bound to the shared vibration state.
class VibrationButton extends StatelessWidget {
  const VibrationButton({
    super.key,
    required this.vibration,
    required this.onToggle,
  });

  final ValueListenable<bool> vibration;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: vibration,
      builder: (_, on, _) => GlassIconButton(
        icon: on ? Icons.vibration : Icons.mobile_off,
        label: on ? 'Vibration on' : 'Vibration off',
        onPressed: onToggle,
      ),
    );
  }
}
