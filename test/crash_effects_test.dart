import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:fright_flight/core/game_config.dart';
import 'package:fright_flight/game/logic/crash_effects.dart';

double offset(CrashEffects e) =>
    sqrt(e.shakeX * e.shakeX + e.shakeY * e.shakeY);

void main() {
  test('idle: no shake and no flash', () {
    final e = CrashEffects(Random(1))..update(0.1);
    expect(offset(e), 0);
    expect(e.flashAlpha, 0);
  });

  test('shake decays and returns to zero after its duration', () {
    final e = CrashEffects(Random(1))..start(reducedMotion: false);
    expect(offset(e), closeTo(GameConfig.crashShakeAmplitude, 1e-9));
    var t = 0.0;
    while (t < GameConfig.crashShakeDuration) {
      e.update(0.02);
      t += 0.02;
      final limit =
          GameConfig.crashShakeAmplitude *
          max(0, 1 - t / GameConfig.crashShakeDuration);
      expect(offset(e), lessThanOrEqualTo(limit + 1e-9));
    }
    e.update(0.02);
    expect(offset(e), 0);
  });

  test('flash fades to zero after its duration', () {
    final e = CrashEffects()..start(reducedMotion: false);
    expect(e.flashAlpha, closeTo(GameConfig.crashFlashAlpha, 1e-9));
    e.update(GameConfig.crashFlashDuration / 2);
    expect(e.flashAlpha, closeTo(GameConfig.crashFlashAlpha / 2, 1e-9));
    e.update(GameConfig.crashFlashDuration);
    expect(e.flashAlpha, 0);
  });

  test('reduced motion: flash but no shake', () {
    final e = CrashEffects(Random(1))..start(reducedMotion: true);
    expect(e.flashAlpha, greaterThan(0));
    for (var i = 0; i < 10; i++) {
      expect(offset(e), 0);
      e.update(0.02);
    }
  });

  test('clear stops both at once', () {
    final e = CrashEffects(Random(1))..start(reducedMotion: false);
    e.update(0.05);
    e.clear();
    expect(offset(e), 0);
    expect(e.flashAlpha, 0);
    e.update(0.05);
    expect(offset(e), 0);
  });
}
