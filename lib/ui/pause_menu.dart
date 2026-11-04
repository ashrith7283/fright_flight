import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'glass_panel.dart';
import 'pill_button.dart';
import 'settings_toggles.dart';

class PauseMenu extends StatelessWidget {
  const PauseMenu({
    super.key,
    required this.onResume,
    required this.onMenu,
    required this.muted,
    required this.onToggleMute,
    required this.vibration,
    required this.onToggleVibration,
  });

  final VoidCallback onResume;
  final VoidCallback onMenu;
  final ValueListenable<bool> muted;
  final VoidCallback onToggleMute;
  final ValueListenable<bool> vibration;
  final VoidCallback onToggleVibration;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black38,
      child: SafeArea(
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: GlassPanel(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'PAUSED',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 6,
                    ),
                  ),
                  const SizedBox(height: 16),
                  PillButton(
                    label: 'Resume',
                    icon: Icons.play_arrow_rounded,
                    onPressed: onResume,
                  ),
                  const SizedBox(height: 10),
                  PillButton(
                    label: 'Menu',
                    icon: Icons.home_rounded,
                    onPressed: onMenu,
                    primary: false,
                  ),
                  const SizedBox(height: 16),
                  SettingsToggles(
                    muted: muted,
                    onToggleMute: onToggleMute,
                    vibration: vibration,
                    onToggleVibration: onToggleVibration,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
