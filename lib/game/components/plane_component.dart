import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';

import '../../core/game_config.dart';
import '../logic/plane_body.dart';

/// Side-view aeroplane drawn inside the configured plane footprint. Tilt and
/// propeller are cosmetic; collisions use [PlaneBody] only.
class PlaneComponent extends PositionComponent {
  PlaneComponent(this.body, {bool Function()? isRunning})
    : _isRunning = isRunning ?? (() => false),
      super(
        position: Vector2(GameConfig.planeStartX, GameConfig.planeStartY),
        size: Vector2(GameConfig.planeWidth, GameConfig.planeHeight),
        priority: 2,
      );

  final PlaneBody body;
  final bool Function() _isRunning;
  double _spin = 0;
  double _tilt = 0; // eased, so taps do not snap the nose

  static final _fuselage = Paint()..color = GameConfig.planeBodyColor;
  static final _wing = Paint()..color = GameConfig.planeWingColor;
  static final _window = Paint()..color = GameConfig.planeWindowColor;
  static final _stripe = Paint()..color = const Color(0xFFFFFFFF);
  static final _hub = Paint()..color = const Color(0xFF424242);
  static final _blade = Paint()
    ..color = const Color(0x99424242)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.5
    ..strokeCap = StrokeCap.round;

  @override
  void update(double dt) {
    position.y = body.y;
    final target =
        (body.velocity / GameConfig.maxFallSpeed).clamp(-1.0, 1.0) *
        GameConfig.planeMaxTilt;
    _tilt += (target - _tilt) * (1 - exp(-GameConfig.planeTiltEaseRate * dt));
    if (_isRunning()) _spin += GameConfig.propellerSpinRate * dt;
  }

  @override
  void render(Canvas canvas) {
    final w = size.x, h = size.y;
    canvas.save();
    canvas.translate(w / 2, h / 2);
    canvas.rotate(_tilt);
    canvas.translate(-w / 2, -h / 2);

    // Tail fin.
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.05, h * 0.50)
        ..lineTo(w * 0.02, h * 0.05)
        ..lineTo(w * 0.22, h * 0.40)
        ..close(),
      _wing,
    );
    // Tail plane.
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.06, h * 0.52)
        ..lineTo(w * 0.00, h * 0.68)
        ..lineTo(w * 0.28, h * 0.60)
        ..close(),
      _wing,
    );
    // Fuselage with tapered tail and rounded nose.
    final body_ = Path()
      ..moveTo(w * 0.04, h * 0.50)
      ..quadraticBezierTo(w * 0.25, h * 0.38, w * 0.55, h * 0.32)
      ..quadraticBezierTo(w * 0.90, h * 0.30, w * 0.92, h * 0.55)
      ..quadraticBezierTo(w * 0.90, h * 0.80, w * 0.55, h * 0.78)
      ..quadraticBezierTo(w * 0.25, h * 0.72, w * 0.04, h * 0.56)
      ..close();
    canvas.drawPath(body_, _fuselage);
    // White stripe along the fuselage.
    canvas.drawRect(
      Rect.fromLTWH(w * 0.30, h * 0.58, w * 0.58, h * 0.05),
      _stripe,
    );
    // Cockpit window.
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.56, h * 0.38, w * 0.2, h * 0.17),
        const Radius.circular(3),
      ),
      _window,
    );
    // Wing.
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.38, h * 0.55)
        ..lineTo(w * 0.30, h * 0.95)
        ..lineTo(w * 0.52, h * 0.95)
        ..lineTo(w * 0.64, h * 0.55)
        ..close(),
      _wing,
    );
    // Propeller: hub plus a blade whose length oscillates as it spins.
    final cx = w * 0.95, cy = h * 0.55;
    final blade = h * 0.42 * cos(_spin);
    canvas.drawLine(Offset(cx, cy - blade), Offset(cx, cy + blade), _blade);
    canvas.drawCircle(Offset(cx - 1, cy), 2.4, _hub);
    canvas.restore();
  }
}
