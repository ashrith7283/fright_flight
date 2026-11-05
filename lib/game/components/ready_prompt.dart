import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

import '../../core/game_config.dart';
import '../logic/run_controller.dart';

/// Pulsing "TAP TO FLY" hint, drawn only in the ready state.
class ReadyPrompt extends PositionComponent {
  ReadyPrompt({required this.runState})
    : super(
        position: Vector2(GameConfig.promptX, GameConfig.promptY),
        anchor: Anchor.center,
        priority: 10,
      );

  final RunState Function() runState;
  double _time = 0;

  static const text = 'TAP TO FLY';
  static const _steps = 8; // cached alpha levels, so no paint per frame

  static final List<TextPaint> _paints = [
    for (var i = 0; i < _steps; i++)
      TextPaint(
        style: TextStyle(
          color: GameConfig.scoreTextColor.withValues(
            alpha:
                GameConfig.promptMinAlpha +
                (1 - GameConfig.promptMinAlpha) * i / (_steps - 1),
          ),
          fontSize: GameConfig.promptFontSize,
          fontWeight: FontWeight.w900,
          letterSpacing: 4,
          shadows: const [
            Shadow(
              color: Color(0x99000000),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
      ),
  ];

  bool get isVisible => runState() == RunState.ready;

  /// Current opacity, between [GameConfig.promptMinAlpha] and 1.
  double get alpha {
    final wave = 0.5 + 0.5 * cos(2 * pi * _time / GameConfig.promptPulsePeriod);
    return GameConfig.promptMinAlpha + (1 - GameConfig.promptMinAlpha) * wave;
  }

  @override
  void update(double dt) {
    // Restart the pulse at full brightness each time ready is entered.
    _time = isVisible ? _time + dt : 0;
  }

  @override
  void render(Canvas canvas) {
    if (!isVisible) return;
    final level =
        ((alpha - GameConfig.promptMinAlpha) /
                (1 - GameConfig.promptMinAlpha) *
                (_steps - 1))
            .round();
    _paints[level].render(canvas, text, Vector2.zero(), anchor: Anchor.center);
  }
}
