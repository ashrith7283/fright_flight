import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

import '../../core/game_config.dart';

/// "CLOSE!" text that rises from the plane and fades, then removes itself.
/// Its clock stops while [isPaused] returns true.
class NearMissLabel extends PositionComponent {
  NearMissLabel({required Vector2 at, required this.isPaused})
    : _startY = at.y,
      super(position: at, anchor: Anchor.center, priority: 20);

  final bool Function() isPaused;
  final double _startY;
  double _age = 0;

  static const text = 'CLOSE!';
  static const _steps = 6; // cached fade levels, so no paint per frame

  static final List<TextPaint> _paints = [
    for (var i = 1; i <= _steps; i++)
      TextPaint(
        style: TextStyle(
          color: const Color(0xFFFFEB3B).withValues(alpha: i / _steps),
          fontSize: 18,
          fontWeight: FontWeight.w900,
          letterSpacing: 2,
          shadows: const [
            Shadow(
              color: Color(0x99000000),
              blurRadius: 3,
              offset: Offset(0, 1),
            ),
          ],
        ),
      ),
  ];

  /// 0 when shown, 1 when gone.
  double get progress => (_age / GameConfig.nearMissLabelDuration).clamp(0, 1);

  @override
  void update(double dt) {
    if (isPaused()) return;
    _age += dt;
    position.y = _startY - GameConfig.nearMissLabelRise * progress;
    if (progress >= 1) removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    final level = ((1 - progress) * _steps).ceil().clamp(0, _steps);
    if (level == 0) return;
    _paints[level - 1].render(canvas, text, Vector2.zero());
  }
}
