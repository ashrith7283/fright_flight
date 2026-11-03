import 'package:flutter/material.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key, required this.highScore, required this.onPlay});

  final int highScore;
  final VoidCallback onPlay;

  static const _shadows = [
    Shadow(color: Color(0x66000000), blurRadius: 8, offset: Offset(0, 3)),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'FRIGHT',
              style: TextStyle(
                color: Colors.white,
                fontSize: 60,
                height: 1,
                fontWeight: FontWeight.w900,
                letterSpacing: 8,
                shadows: [
                  Shadow(color: Color(0xFFB71C1C), offset: Offset(0, 4)),
                  ..._shadows,
                ],
              ),
            ),
            const Text(
              'FLIGHT',
              style: TextStyle(
                color: Color(0xFFFFEB3B),
                fontSize: 60,
                height: 1.05,
                fontWeight: FontWeight.w900,
                letterSpacing: 8,
                shadows: [
                  Shadow(color: Color(0xFFB71C1C), offset: Offset(0, 4)),
                  ..._shadows,
                ],
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'BEST  $highScore',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 3,
                ),
              ),
            ),
            const SizedBox(height: 22),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFD32F2F),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 48,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 4,
                textStyle: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 4,
                ),
              ),
              onPressed: onPlay,
              child: const Text('PLAY'),
            ),
          ],
        ),
      ),
    );
  }
}
