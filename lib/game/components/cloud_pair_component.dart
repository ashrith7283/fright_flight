import 'dart:ui';

import 'package:flame/components.dart';

import '../../core/game_config.dart';
import '../logic/cloud_pair_spec.dart';

class CloudPairComponent extends PositionComponent {
  CloudPairComponent(this.spec)
    : super(
        position: Vector2(spec.x, 0),
        size: Vector2(GameConfig.cloudWidth, GameConfig.worldHeight),
        priority: 1,
      );

  final CloudPairSpec spec;
  static final _paint = Paint()..color = const Color(0xFFF5F5F5);

  @override
  void update(double dt) => position.x = spec.x;

  @override
  void render(Canvas canvas) {
    const r = Radius.circular(24);
    canvas.drawRRect(RRect.fromLTRBR(0, -200, size.x, spec.gapTop, r), _paint);
    canvas.drawRRect(
      RRect.fromLTRBR(0, spec.gapBottom, size.x, GameConfig.groundTop + 24, r),
      _paint,
    );
  }
}
