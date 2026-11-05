import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../game/logic/medals.dart';
import 'glass_panel.dart';
import 'medal_badge.dart';
import 'pill_button.dart';
import 'settings_toggles.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({
    super.key,
    required this.highScore,
    required this.onPlay,
    required this.muted,
    required this.onToggleMute,
    required this.vibration,
    required this.onToggleVibration,
    this.runsPlayed = 0,
  });

  final int highScore;

  /// Finished runs so far.
  final int runsPlayed;
  final VoidCallback onPlay;
  final ValueListenable<bool> muted;
  final VoidCallback onToggleMute;
  final ValueListenable<bool> vibration;
  final VoidCallback onToggleVibration;

  static const _shadow = [
    Shadow(color: Color(0x66000000), blurRadius: 8, offset: Offset(0, 3)),
  ];

  static TextStyle _title(Color color) => TextStyle(
    color: color,
    fontSize: 48,
    height: 1,
    fontWeight: FontWeight.w900,
    letterSpacing: 8,
    shadows: const [
      Shadow(color: Color(0xFFB71C1C), offset: Offset(0, 4)),
      ..._shadow,
    ],
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: SettingsToggles(
                muted: muted,
                onToggleMute: onToggleMute,
                vibration: vibration,
                onToggleVibration: onToggleVibration,
              ),
            ),
          ),
          // FittedBox shrinks the card on short screens so it never overflows.
          Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: GlassPanel(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('FRIGHT', style: _title(Colors.white)),
                    const SizedBox(height: 4),
                    Text('FLIGHT', style: _title(const Color(0xFFFFEB3B))),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.emoji_events,
                            color: Color(0xFFFFD54F),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'BEST  $highScore',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 3,
                            ),
                          ),
                          if (Medals.forScore(highScore) case final medal?) ...[
                            const SizedBox(width: 8),
                            MedalBadge(medal: medal, showLabel: false),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'RUNS  $runsPlayed',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 3,
                      ),
                    ),
                    const SizedBox(height: 14),
                    PillButton(
                      label: 'Play',
                      icon: Icons.play_arrow_rounded,
                      onPressed: onPlay,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
