import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:fright_flight/core/game_config.dart';
import 'package:fright_flight/game/logic/cloud_field.dart';
import 'package:fright_flight/game/logic/collision_rules.dart';
import 'package:fright_flight/game/logic/gap_generator.dart';
import 'package:fright_flight/game/logic/plane_body.dart';

void main() {
  test('gaps respect margins, vary and respect maxGapShift', () {
    final g = GapGenerator(Random(1));
    const half = GameConfig.gapSize / 2;
    double? prev;
    final seen = <double>{};
    for (var i = 0; i < 2000; i++) {
      final c = g.next(prev);
      expect(c - half, greaterThanOrEqualTo(GameConfig.ceilingMargin));
      expect(
        c + half,
        lessThanOrEqualTo(GameConfig.groundTop - GameConfig.groundMargin),
      );
      if (prev != null) {
        expect((c - prev).abs(), lessThanOrEqualTo(GameConfig.maxGapShift));
      }
      seen.add(c);
      prev = c;
    }
    expect(seen.length, greaterThan(1000));
  });

  test('a flap path can clear consecutive generated gaps', () {
    for (var seed = 0; seed < 20; seed++) {
      final field = CloudField(GapGenerator(Random(seed)));
      final plane = PlaneBody();
      const dt = 1 / 60;
      var spawned = 0;
      while (spawned < 30) {
        spawned += field.step(dt).length;
        // Aim for the centre of the next pair still ahead of / over the plane.
        final ahead = field.pairs.where(
          (p) => p.right > GameConfig.planeStartX,
        );
        final target = ahead.isEmpty
            ? GameConfig.planeStartY
            : ahead.first.gapCentre;
        if (plane.y + GameConfig.planeHeight / 2 > target + 20) plane.flap();
        plane.step(dt);
        expect(
          CollisionRules.hits(plane.y, field.pairs),
          isFalse,
          reason: 'seed $seed crashed after $spawned pairs',
        );
      }
    }
  });
}
