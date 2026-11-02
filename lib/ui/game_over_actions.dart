import 'package:flutter/material.dart';

import '../core/game_config.dart';

class GameOverActions extends StatelessWidget {
  const GameOverActions({
    super.key,
    required this.onRestart,
    required this.onMenu,
  });

  final VoidCallback onRestart;
  final VoidCallback onMenu;

  @override
  Widget build(BuildContext context) {
    final top =
        MediaQuery.sizeOf(context).height *
        GameConfig.gameOverActionsTopFraction;
    return Padding(
      padding: EdgeInsets.only(top: top),
      child: Align(
        alignment: Alignment.topCenter,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FilledButton(onPressed: onRestart, child: const Text('Restart')),
            const SizedBox(width: 12),
            OutlinedButton(
              style: OutlinedButton.styleFrom(foregroundColor: Colors.white),
              onPressed: onMenu,
              child: const Text('Menu'),
            ),
          ],
        ),
      ),
    );
  }
}
