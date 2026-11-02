import 'dart:ui';

import 'package:flame/components.dart';

import '../../core/game_config.dart';
import '../logic/cloud_spec.dart';

class CloudComponent extends PositionComponent {
  CloudComponent(this.spec)
    : super(
        position: Vector2(spec.x, spec.bounds.top),
        size: Vector2(GameConfig.cloudWidth, GameConfig.cloudHeight),
        priority: 1,
      );

  final CloudSpec spec;
  static final _paint = Paint()..color = const Color(0xFFF5F5F5);

  @override
  void update(double dt) => position.x = spec.x;

  @override
  void render(Canvas canvas) => canvas.drawOval(size.toRect(), _paint);
}
