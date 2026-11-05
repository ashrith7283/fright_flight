import 'dart:math';

import '../../core/game_config.dart';

/// Timing of the crash flash and screen shake. Plain Dart; the game applies
/// [shakeX]/[shakeY] to the camera and draws the flash with [flashAlpha].
/// Purely cosmetic: nothing here feeds back into gameplay.
class CrashEffects {
  CrashEffects([Random? random]) : _random = random ?? Random();

  final Random _random;
  double _shakeT = GameConfig.crashShakeDuration; // time since the crash
  double _flashT = GameConfig.crashFlashDuration;
  bool _shaking = false;

  double shakeX = 0;
  double shakeY = 0;

  /// Starts both effects; the shake is skipped when [reducedMotion] is set.
  void start({required bool reducedMotion}) {
    _flashT = 0;
    _shakeT = 0;
    _shaking = !reducedMotion;
    _roll();
  }

  /// Stops both effects at once (restart, return to menu).
  void clear() {
    _flashT = GameConfig.crashFlashDuration;
    _shakeT = GameConfig.crashShakeDuration;
    _shaking = false;
    shakeX = 0;
    shakeY = 0;
  }

  double get flashAlpha {
    if (_flashT >= GameConfig.crashFlashDuration) return 0;
    return GameConfig.crashFlashAlpha *
        (1 - _flashT / GameConfig.crashFlashDuration);
  }

  void update(double dt) {
    _flashT = min(_flashT + dt, GameConfig.crashFlashDuration);
    _shakeT = min(_shakeT + dt, GameConfig.crashShakeDuration);
    _roll();
  }

  /// A new random direction each frame, shrinking to zero by the end.
  void _roll() {
    if (!_shaking || _shakeT >= GameConfig.crashShakeDuration) {
      shakeX = 0;
      shakeY = 0;
      return;
    }
    final size =
        GameConfig.crashShakeAmplitude *
        (1 - _shakeT / GameConfig.crashShakeDuration);
    final angle = _random.nextDouble() * 2 * pi;
    shakeX = size * cos(angle);
    shakeY = size * sin(angle);
  }
}
