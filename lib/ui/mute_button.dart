import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Speaker toggle bound to the shared mute state.
class MuteButton extends StatelessWidget {
  const MuteButton({super.key, required this.muted, required this.onToggle});

  final ValueListenable<bool> muted;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: muted,
      builder: (_, isMuted, _) => IconButton.filledTonal(
        tooltip: isMuted ? 'Unmute' : 'Mute',
        onPressed: onToggle,
        icon: Icon(isMuted ? Icons.volume_off : Icons.volume_up),
      ),
    );
  }
}
