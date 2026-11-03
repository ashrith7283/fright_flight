import 'dart:ui';

import 'package:flame/components.dart';

import '../../core/game_config.dart';
import '../logic/plane_body.dart';
import '../logic/smoke_puffs.dart';

/// Smoke behind the plane. Emits and ages puffs only while [isRunning].
class SmokeTrail extends Component {
  SmokeTrail(this.body, {required this._isRunning}) : super(priority: 1);

  final PlaneBody body;
  final bool Function() _isRunning;
  final SmokePuffs _puffs = SmokePuffs();
  final Paint _paint = Paint();

  void clear() => _puffs.clear();

  @override
  void update(double dt) {
    if (!_isRunning()) return;
    _puffs.step(
      dt,
      spawnX: GameConfig.planeStartX + 2,
      spawnY: body.y + GameConfig.planeHeight * 0.55,
    );
  }

  @override
  void render(Canvas canvas) {
    for (final p in _puffs.puffs) {
      final t = p.progress.clamp(0.0, 1.0);
      _paint.color = GameConfig.smokeColor.withValues(
        alpha: GameConfig.smokeStartAlpha * (1 - t),
      );
      canvas.drawCircle(
        Offset(p.x, p.y),
        GameConfig.smokeStartRadius +
            (GameConfig.smokeEndRadius - GameConfig.smokeStartRadius) * t,
        _paint,
      );
    }
  }
}
