import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'mute_button.dart';

class PauseMenu extends StatelessWidget {
  const PauseMenu({
    super.key,
    required this.onResume,
    required this.onMenu,
    required this.muted,
    required this.onToggleMute,
  });

  final VoidCallback onResume;
  final VoidCallback onMenu;
  final ValueListenable<bool> muted;
  final VoidCallback onToggleMute;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black38,
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Paused',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(onPressed: onResume, child: const Text('Resume')),
              const SizedBox(height: 8),
              OutlinedButton(
                style: OutlinedButton.styleFrom(foregroundColor: Colors.white),
                onPressed: onMenu,
                child: const Text('Menu'),
              ),
              const SizedBox(height: 8),
              MuteButton(muted: muted, onToggle: onToggleMute),
            ],
          ),
        ),
      ),
    );
  }
}
