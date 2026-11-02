import 'dart:ui';

import 'package:flame/components.dart';

import '../../core/game_config.dart';

/// Sky and ground, drawn with placeholder rects.
class BackgroundComponent extends PositionComponent {
  BackgroundComponent()
    : super(size: Vector2(GameConfig.worldWidth, GameConfig.worldHeight));

  static final _sky = Paint()..color = GameConfig.skyColor;
  static final _ground = Paint()..color = const Color(0xFF6B8E23);

  @override
  void render(Canvas canvas) {
    // Oversized sky so letterbox bars match the sky colour.
    canvas.drawRect(const Rect.fromLTWH(-2000, -2000, 4400, 4800), _sky);
    canvas.drawRect(
      const Rect.fromLTWH(
        -2000,
        GameConfig.groundTop,
        4400,
        GameConfig.groundHeight + 2000,
      ),
      _ground,
    );
  }
}
