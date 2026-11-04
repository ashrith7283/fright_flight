import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';

import '../../core/game_config.dart';
import '../logic/sky_palette.dart';

/// Sky (shifting with the score), sun, birds, mountains, haze and hills.
/// Purely cosmetic: layers scroll only while [isRunning] returns true and
/// nothing here takes part in collisions.
class BackgroundComponent extends PositionComponent {
  BackgroundComponent({bool Function()? isRunning, int Function()? score})
    : _isRunning = isRunning ?? (() => false),
      _score = score ?? (() => 0),
      super(size: Vector2(GameConfig.worldWidth, GameConfig.worldHeight));

  final bool Function() _isRunning;
  final int Function() _score;
  double _hillOffset = 0;
  double _mountainOffset = 0;
  double _hazeOffset = 0;
  double _time = 0;
  SkyState _sky = SkyPalette.day; // eased towards the score's target

  /// Currently displayed sky, exposed for tests.
  SkyState get sky => _sky;

  static final _skyPaint = Paint();
  Color? _shaderTop; // gradient cache: rebuilt only when the colours change
  Color? _shaderBottom;
  static final _fillTop = Paint();
  static final _fillBottom = Paint();
  static final _sunGlow = Paint();
  static final _sun = Paint();
  static final _hillFar = Paint()..color = GameConfig.hillFarColor;
  static final _hillNear = Paint()..color = GameConfig.hillNearColor;
  static final _mountain = Paint();
  static final _haze = Paint()..color = GameConfig.hazeColor;
  static final _ground = Paint()..color = GameConfig.groundColor;
  static final _groundDark = Paint()..color = GameConfig.groundDarkColor;

  static const double _hillPeriod = 400;
  static const double _layerPeriod = GameConfig.worldWidth;

  static final _birdPaint = Paint()
    ..color = GameConfig.birdColor
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.8
    ..strokeCap = StrokeCap.round;

  // One repeat of the mountain range (x within 0.._layerPeriod, wraps).
  static final Path _mountainPath = _buildMountains();

  static Path _buildMountains() {
    const base = GameConfig.groundTop;
    const peaks = <List<double>>[
      [0, 0],
      [90, 120],
      [200, 40],
      [310, 150],
      [430, 60],
      [540, 135],
      [660, 50],
      [800, 0],
    ];
    final p = Path()..moveTo(0, base);
    for (final pk in peaks) {
      p.lineTo(pk[0], base - 20 - pk[1]);
    }
    return p
      ..lineTo(_layerPeriod, base)
      ..close();
  }

  @override
  void update(double dt) {
    // The sky eases towards the score's palette in every state, so a restart
    // returns to day smoothly instead of jumping.
    final k = 1 - exp(-GameConfig.skyEaseRate * dt);
    _sky = SkyState.lerp(_sky, SkyPalette.at(_score()), k);
    if (!_isRunning()) return;
    _time += dt;
    _mountainOffset =
        (_mountainOffset +
            GameConfig.scrollSpeed * GameConfig.bgMountainParallax * dt) %
        _layerPeriod;
    _hazeOffset =
        (_hazeOffset +
            GameConfig.scrollSpeed * GameConfig.bgHazeParallax * dt) %
        _layerPeriod;
    _hillOffset =
        (_hillOffset +
            GameConfig.scrollSpeed * GameConfig.bgHillParallax * dt) %
        _hillPeriod;
  }

  @override
  void render(Canvas canvas) {
    // Oversized so letterbox bars match: flat fills beyond the gradient span.
    _fillTop.color = _sky.top;
    _fillBottom.color = _sky.bottom;
    canvas.drawRect(const Rect.fromLTWH(-2000, -2000, 4400, 2000), _fillTop);
    canvas.drawRect(
      const Rect.fromLTWH(-2000, GameConfig.groundTop - 1, 4400, 100),
      _fillBottom,
    );
    if (_shaderTop != _sky.top || _shaderBottom != _sky.bottom) {
      _shaderTop = _sky.top;
      _shaderBottom = _sky.bottom;
      _skyPaint.shader = Gradient.linear(
        Offset.zero,
        const Offset(0, GameConfig.groundTop),
        [_sky.top, _sky.bottom],
      );
    }
    canvas.drawRect(
      const Rect.fromLTWH(-2000, 0, 4400, GameConfig.groundTop),
      _skyPaint,
    );

    // Sun: lowers and warms as the score rises.
    _sunGlow.color = _sky.sunColor.withValues(alpha: 0.3);
    _sun.color = _sky.sunColor;
    canvas.drawCircle(Offset(GameConfig.sunX, _sky.sunY), 42, _sunGlow);
    canvas.drawCircle(Offset(GameConfig.sunX, _sky.sunY), 26, _sun);

    // Birds: move and flap only while running.
    for (final b in GameConfig.birds) {
      final span = GameConfig.worldWidth + 2 * GameConfig.birdWingspan;
      final x = ((b[0] - b[2] * _time) % span) - GameConfig.birdWingspan;
      final flap = sin(_time * GameConfig.birdFlapRate + b[3]);
      _bird(canvas, x, b[1], flap);
    }

    // Far mountains (slowest), tinted towards the sky for depth.
    _mountain.color = Color.lerp(GameConfig.mountainColor, _sky.bottom, 0.45)!;
    for (final dx in [-_mountainOffset, _layerPeriod - _mountainOffset]) {
      canvas.save();
      canvas.translate(dx, 0);
      canvas.drawPath(_mountainPath, _mountain);
      canvas.restore();
    }

    // Drifting haze band.
    for (final dx in [-_hazeOffset, _layerPeriod - _hazeOffset]) {
      for (final h in const [
        [100.0, 270.0, 200.0, 26.0],
        [380.0, 245.0, 240.0, 30.0],
        [640.0, 285.0, 220.0, 24.0],
      ]) {
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(h[0] + dx, h[1]),
            width: h[2],
            height: h[3],
          ),
          _haze,
        );
      }
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
