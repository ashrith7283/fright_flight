import 'package:flutter/material.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key, required this.highScore, required this.onPlay});

  final int highScore;
  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Fright Flight',
              style: TextStyle(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'High score: $highScore',
              style: const TextStyle(color: Colors.white, fontSize: 22),
            ),
            const SizedBox(height: 24),
            FilledButton(onPressed: onPlay, child: const Text('Play')),
          ],
        ),
      ),
    );
  }
}
