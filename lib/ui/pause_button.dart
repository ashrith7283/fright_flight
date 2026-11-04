import 'package:flutter/material.dart';

import 'glass_icon_button.dart';

class PauseButton extends StatelessWidget {
  const PauseButton({super.key, required this.onPause});

  final VoidCallback onPause;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: GlassIconButton(
            icon: Icons.pause_rounded,
            label: 'Pause',
            onPressed: onPause,
          ),
        ),
      ),
    );
  }
}
