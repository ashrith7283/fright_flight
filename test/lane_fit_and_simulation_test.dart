import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:fright_flight/core/game_config.dart';
import 'package:fright_flight/game/logic/cloud_field.dart';
import 'package:fright_flight/game/logic/collision_rules.dart';
import 'package:fright_flight/game/logic/lane_picker.dart';
import 'package:fright_flight/game/logic/plane_body.dart';

void main() {
  const hitboxHeight = GameConfig.planeHeight - 2 * GameConfig.planeHitboxInset;

  test('plane fits above, between and below lane clouds', () {
    const above = (GameConfig.laneHeight - GameConfig.cloudHeight) / 2;
    const between = GameConfig.laneHeight - GameConfig.cloudHeight;
    expect(above, greaterThan(hitboxHeight));
    expect(between, greaterThan(hitboxHeight));
    expect(GameConfig.maxCloudsPerGroup, lessThan(GameConfig.laneCount));
  });

  // (speed, score): the start of a run, and the hardest point of the ramp
  // (top speed, minimum spacing, most two-cloud groups, moving clouds on).
  // The plane body applies the soft ceiling.
  const hardest = GameConfig.rampEndScore + GameConfig.movingCloudScore;
  for (final (speed, score) in [
    (GameConfig.scrollSpeed, 0),
    (GameConfig.maxScrollSpeed, hardest),
  ]) {
    test(
      'a rate-limited flap path clears 30 groups on 20 seeds at speed $speed, score $score',
      () {
        for (var seed = 0; seed < 20; seed++) {
          final field = CloudField(LanePicker(Random(seed)));
          final plane = PlaneBody();
          const dt = 1 / 60;
          var spawnedGroups = 0, sinceFlap = 1.0;
          while (spawnedGroups < 30) {
            if (field.step(dt, speed: speed, score: score).isNotEmpty) {
              spawnedGroups++;
            }
            final plane0 = GameConfig.planeStartX;
            final ahead = field.clouds.where((c) => c.right > plane0).toList();
            var target = GameConfig.groundTop / 2;
            if (ahead.isNotEmpty) {
              final x = ahead.map((c) => c.x).reduce(min);
              final busy = ahead
                  .where((c) => c.x == x)
                  .map((c) => c.lane)
                  .toSet();
              final free = [
                for (var l = 0; l < GameConfig.laneCount; l++)
                  if (!busy.contains(l)) l,
              ];
              final here = plane.y + GameConfig.planeHeight / 2;
              final centres = [
                for (final l in free) (l + 0.5) * GameConfig.laneHeight,
              ];
              // Nearest free lane keeps lane changes as short as possible.
              target = centres.reduce(
                (a, b) => (a - here).abs() <= (b - here).abs() ? a : b,
              );
            }
            sinceFlap += dt;
            final centre = plane.y + GameConfig.planeHeight / 2;
            if (centre > target + 15 && sinceFlap > 0.15) {
              plane.flap();
              sinceFlap = 0;
            }
            plane.step(dt);
            expect(
              CollisionRules.hits(plane.y, field.clouds),
              isFalse,
              reason:
                  'seed $seed crashed after $spawnedGroups groups y=${plane.y} v=${plane.velocity} target=$target clouds=${field.clouds.map((c) => "${c.lane}@${c.x.round()}").toList()}',
            );
          }
        }
      },
    );
  }
}
