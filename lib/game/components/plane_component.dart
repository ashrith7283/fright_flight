import 'dart:ui';

import 'package:flame/components.dart';

import '../../core/game_config.dart';
import '../logic/plane_body.dart';

class PlaneComponent extends PositionComponent {
  PlaneComponent(this.body)
    : super(
        position: Vector2(GameConfig.planeStartX, GameConfig.planeStartY),
        size: Vector2(GameConfig.planeWidth, GameConfig.planeHeight),
        priority: 2,
      );

  final PlaneBody body;
  static final _paint = Paint()..color = const Color(0xFFD32F2F);

  @override
  void update(double dt) => position.y = body.y;

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(size.toRect(), const Radius.circular(10)),
      _paint,
    );
  }
}
