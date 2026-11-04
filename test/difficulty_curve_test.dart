import 'package:flutter_test/flutter_test.dart';
import 'package:fright_flight/core/game_config.dart';
import 'package:fright_flight/game/logic/cloud_field.dart';
import 'package:fright_flight/game/logic/difficulty_curve.dart';
import 'package:fright_flight/game/logic/lane_picker.dart';

void main() {
  test('starts at the base speed', () {
    expect(DifficultyCurve.speedFor(0), GameConfig.scrollSpeed);
  });

  test('rises by the configured amount per point', () {
    expect(
      DifficultyCurve.speedFor(5) - DifficultyCurve.speedFor(4),
      GameConfig.scrollSpeedPerPoint,
    );
  });

  test('is capped at the maximum speed', () {
    expect(DifficultyCurve.speedFor(100000), GameConfig.maxScrollSpeed);
    expect(DifficultyCurve.speedFor(-3), GameConfig.scrollSpeed);
  });

  test('is monotonic and never above the cap', () {
    var last = 0.0;
    for (var s = 0; s < 200; s++) {
      final v = DifficultyCurve.speedFor(s);
      expect(v, greaterThanOrEqualTo(last));
      expect(v, lessThanOrEqualTo(GameConfig.maxScrollSpeed));
      last = v;
    }
  });

  test('spawn spacing stays fixed in distance at higher speed', () {
    final f = CloudField(LanePicker());
    for (var t = 0.0; t < 8; t += 1 / 60) {
      f.step(1 / 60, speed: GameConfig.maxScrollSpeed);
    }
    final xs = f.clouds.map((c) => c.x).toSet().toList()..sort();
    expect(xs.length, greaterThan(1));
    for (var i = 1; i < xs.length; i++) {
      expect(xs[i] - xs[i - 1], closeTo(GameConfig.spawnSpacing, 1e-6));
    }
  });

  test('clouds move at the given speed', () {
    final f = CloudField(LanePicker());
    f.step(
      (GameConfig.firstGroupDistance + 1) / GameConfig.maxScrollSpeed,
      speed: GameConfig.maxScrollSpeed,
    );
    final x0 = f.clouds.first.x;
    f.step(0.1, speed: GameConfig.maxScrollSpeed);
    expect(
      x0 - f.clouds.first.x,
      closeTo(GameConfig.maxScrollSpeed * 0.1, 1e-6),
    );
  });
}
