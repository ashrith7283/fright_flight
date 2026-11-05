import 'dart:ui';

import 'package:flame/components.dart';

import '../../core/game_config.dart';
import '../logic/cloud_spec.dart';

/// Puffy cloud drawn from overlapping lobes, all inside the bounding box.
class CloudComponent extends PositionComponent {
  CloudComponent(this.spec)
    : super(
        position: Vector2(spec.x, spec.bounds.top),
        size: Vector2(GameConfig.cloudWidth, GameConfig.cloudHeight),
        priority: 1,
      );

  final CloudSpec spec;
  static final _paint = Paint()..color = GameConfig.cloudColor;
  static final _shade = Paint()..color = GameConfig.cloudShadeColor;

  // Lobes as (cx, cy, rx, ry) fractions of the bounding box.
  static const _lobes = <List<double>>[
    [0.20, 0.64, 0.20, 0.34],
    [0.40, 0.42, 0.22, 0.42],
    [0.62, 0.38, 0.22, 0.38],
    [0.80, 0.62, 0.20, 0.34],
    [0.50, 0.68, 0.46, 0.30],
  ];

  @override
  void update(double dt) => position.setValues(spec.x, spec.bounds.top);

  @override
  void render(Canvas canvas) {
    final w = size.x, h = size.y;
    // Shaded underside first, nudged down, then the white lobes on top.
    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, 0, w, h));
    _draw(canvas, w, h, _shade, dy: h * 0.07);
    _draw(canvas, w, h, _paint, dy: 0);
    canvas.restore();
  }

  void _draw(Canvas canvas, double w, double h, Paint paint, {double dy = 0}) {
    for (final l in _lobes) {
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(l[0] * w, l[1] * h + dy),
          width: l[2] * 2 * w,
          height: l[3] * 2 * h,
        ),
        paint,
      );
    }
  }
}
