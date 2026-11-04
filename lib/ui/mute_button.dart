import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'glass_icon_button.dart';

/// Speaker toggle bound to the shared mute state.
class MuteButton extends StatelessWidget {
  const MuteButton({super.key, required this.muted, required this.onToggle});

  final ValueListenable<bool> muted;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: muted,
      builder: (_, isMuted, _) => GlassIconButton(
        icon: isMuted ? Icons.volume_off : Icons.volume_up,
        label: isMuted ? 'Unmute' : 'Mute',
        onPressed: onToggle,
      ),
    );
  }
}
