import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';

import '../../core/game_config.dart';

/// Sky gradient, sun and hills. Purely cosmetic: scrolls only
/// while [isRunning] returns true and takes no part in collisions.
class BackgroundComponent extends PositionComponent {
  BackgroundComponent({bool Function()? isRunning})
    : _isRunning = isRunning ?? (() => false),
      super(size: Vector2(GameConfig.worldWidth, GameConfig.worldHeight));

  final bool Function() _isRunning;
  double _hillOffset = 0;
  double _time = 0;

  static final _sky = Paint()
    ..shader = Gradient.linear(
      Offset.zero,
      const Offset(0, GameConfig.groundTop),
      const [GameConfig.skyTopColor, GameConfig.skyBottomColor],
    );
  static final _skyFill = Paint()..color = GameConfig.skyTopColor;
  static final _skyFillBottom = Paint()..color = GameConfig.skyBottomColor;
  static final _sunGlow = Paint()
    ..color = GameConfig.sunColor.withValues(alpha: 0.3);
  static final _sun = Paint()..color = GameConfig.sunColor;
  static final _hillFar = Paint()..color = GameConfig.hillFarColor;
  static final _hillNear = Paint()..color = GameConfig.hillNearColor;
  static final _ground = Paint()..color = GameConfig.groundColor;
  static final _groundDark = Paint()..color = GameConfig.groundDarkColor;

  static const double _hillPeriod = 400;

  static final _birdPaint = Paint()
    ..color = GameConfig.birdColor
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.8
    ..strokeCap = StrokeCap.round;

  @override
  void update(double dt) {
    if (!_isRunning()) return;
    _time += dt;
    _hillOffset =
        (_hillOffset +
            GameConfig.scrollSpeed * GameConfig.bgHillParallax * dt) %
        _hillPeriod;
  }

  @override
  void render(Canvas canvas) {
    // Oversized so letterbox bars match: flat fills beyond the gradient span.
    canvas.drawRect(const Rect.fromLTWH(-2000, -2000, 4400, 2000), _skyFill);
    canvas.drawRect(
      const Rect.fromLTWH(-2000, GameConfig.groundTop - 1, 4400, 100),
      _skyFillBottom,
    );
    canvas.drawRect(
      const Rect.fromLTWH(-2000, 0, 4400, GameConfig.groundTop),
      _sky,
    );

    // Sun (fixed).
    canvas.drawCircle(const Offset(680, 70), 42, _sunGlow);
    canvas.drawCircle(const Offset(680, 70), 26, _sun);

    // Birds: move and flap only while running.
    for (final b in GameConfig.birds) {
      final span = GameConfig.worldWidth + 2 * GameConfig.birdWingspan;
      final x = ((b[0] - b[2] * _time) % span) - GameConfig.birdWingspan;
      final flap = sin(_time * GameConfig.birdFlapRate + b[3]);
      _bird(canvas, x, b[1], flap);
    }

    // Hills: far layer then near layer, scrolling at different rates.
    _hills(canvas, _hillFar, _hillOffset * 0.5, 60, 38);
    _hills(canvas, _hillNear, _hillOffset, 40, 28);

    // Ground with a darker strip and tufts.
    canvas.drawRect(
      const Rect.fromLTWH(
        -2000,
        GameConfig.groundTop,
        4400,
        GameConfig.groundHeight + 2000,
      ),
      _ground,
    );
    canvas.drawRect(
      const Rect.fromLTWH(-2000, GameConfig.groundTop + 14, 4400, 2000),
      _groundDark,
    );
    for (var x = -_hillOffset; x < GameConfig.worldWidth + 40; x += 40) {
      canvas.drawRect(
        Rect.fromLTWH(x, GameConfig.groundTop + 4, 14, 3),
        _groundDark,
      );
    }
  }

  void _hills(
    Canvas canvas,
    Paint paint,
    double offset,
    double base,
    double amp,
  ) {
    const period = _hillPeriod;
    final path = Path()..moveTo(-period, GameConfig.groundTop);
    for (
      var x = -period - offset;
      x < GameConfig.worldWidth + period;
      x += period
    ) {
      path.quadraticBezierTo(
        x + period / 2,
        GameConfig.groundTop - base - amp,
        x + period,
        GameConfig.groundTop,
      );
    }
    path
      ..lineTo(GameConfig.worldWidth + period, GameConfig.groundTop)
      ..close();
    canvas.drawPath(path, paint);
  }

  void _bird(Canvas canvas, double x, double y, double flap) {
    final half = GameConfig.birdWingspan / 2;
    final tip = -flap * half * 0.5; // wing tips swing up and down
    final path = Path()
      ..moveTo(x - half, y + tip)
      ..quadraticBezierTo(x - half / 2, y - 2, x, y)
      ..quadraticBezierTo(x + half / 2, y - 2, x + half, y + tip);
    canvas.drawPath(path, _birdPaint);
  }
}
