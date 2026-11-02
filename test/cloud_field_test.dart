import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:fright_flight/core/game_config.dart';
import 'package:fright_flight/game/logic/cloud_field.dart';
import 'package:fright_flight/game/logic/gap_generator.dart';

CloudField make() => CloudField(GapGenerator(Random(3)));

void main() {
  test('no pairs before first-pair distance', () {
    final f = make();
    f.step((GameConfig.firstPairDistance - 1) / GameConfig.scrollSpeed);
    expect(f.pairs, isEmpty);
  });

  test('spacing between live pairs equals spawnSpacing', () {
    for (final dt in [1 / 60, 0.4]) {
      final f = make();
      var t = 0.0;
      while (t < 6) {
        f.step(dt);
        t += dt;
      }
      for (var i = 1; i < f.pairs.length; i++) {
        expect(
          f.pairs[i].x - f.pairs[i - 1].x,
          closeTo(GameConfig.spawnSpacing, 1e-6),
        );
      }
    }
  });

  test('pairs removed after leaving left edge', () {
    final f = make();
    for (var i = 0; i < 600; i++) {
      f.step(1 / 60);
    }
    expect(f.pairs.every((p) => p.right >= 0), isTrue);
    expect(f.pairs.length, lessThan(5));
  });

  test('scroll is dt-independent', () {
    final a = make(), b = make();
    for (var i = 0; i < 306; i++) {
      a.step(1 / 60);
    }
    b.step(306 / 60);
    expect(a.pairs.last.x, closeTo(b.pairs.last.x, 1e-6));
  });
}
