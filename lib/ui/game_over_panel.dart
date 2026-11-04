import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'glass_panel.dart';
import 'pill_button.dart';

/// Game-over card: score, best, a new-best badge and the Restart and Menu
/// buttons. The buttons stay disabled until [restartReady] turns true.
class GameOverPanel extends StatelessWidget {
  const GameOverPanel({
    super.key,
    required this.score,
    required this.best,
    required this.newBest,
    required this.restartReady,
    required this.onRestart,
    required this.onMenu,
  });

  final int score;
  final int best;
  final bool newBest;
  final ValueListenable<bool> restartReady;
  final VoidCallback onRestart;
  final VoidCallback onMenu;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: GlassPanel(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'GAME OVER',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 6,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'SCORE',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 4,
                  ),
                ),
                Text(
                  '$score',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 56,
                    height: 1.05,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                if (newBest)
                  const _NewBestBadge()
                else
                  Text(
                    'BEST  $best',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 3,
                    ),
                  ),
                const SizedBox(height: 16),
                ValueListenableBuilder<bool>(
                  valueListenable: restartReady,
                  builder: (_, ready, _) => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      PillButton(
                        label: 'Restart',
                        icon: Icons.refresh_rounded,
                        onPressed: ready ? onRestart : null,
                      ),
                      const SizedBox(width: 12),
                      PillButton(
                        label: 'Menu',
                        icon: Icons.home_rounded,
                        onPressed: ready ? onMenu : null,
                        primary: false,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NewBestBadge extends StatelessWidget {
  const _NewBestBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFFFC107),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, size: 18, color: Color(0xFF4E342E)),
          SizedBox(width: 6),
          Text(
            'NEW BEST',
            style: TextStyle(
              color: Color(0xFF4E342E),
              fontSize: 14,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }
}
