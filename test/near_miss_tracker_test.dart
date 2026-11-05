import 'package:flutter_test/flutter_test.dart';
import 'package:fright_flight/core/game_config.dart';
import 'package:fright_flight/game/logic/cloud_spec.dart';
import 'package:fright_flight/game/logic/collision_rules.dart';
import 'package:fright_flight/game/logic/near_miss_tracker.dart';

/// Plane y whose hitbox top sits [gap] world units below [c]'s ellipse bottom
/// at the cloud's centre column.
double yBelow(CloudSpec c, double gap) =>
    c.centreY + GameConfig.cloudHeight / 2 + gap - GameConfig.planeHitboxInset;

/// Slides [clouds] from the right of the plane to fully past it, feeding the
/// tracker each step at height [y]; returns the total events.
int pass(NearMissTracker t, List<CloudSpec> clouds, double y) {
  var events = 0;
  for (var x = 400.0; x > -200; x -= 5) {
    for (final c in clouds) {
      c.x = x;
    }
    events += t.update(y, clouds);
  }
  return events;
}

void main() {
  test('a close pass is a near miss', () {
    final c = CloudSpec(x: 400, lane: 1, groupId: 0);
    final y = yBelow(c, 3);
    expect(CollisionRules.hits(y, [c..x = 150]), isFalse);
    expect(pass(NearMissTracker(), [c], y), 1);
  });

  test('a comfortable pass is not', () {
    final c = CloudSpec(x: 400, lane: 1, groupId: 0);
    expect(pass(NearMissTracker(), [c], yBelow(c, 25)), 0);
  });

  test('at most one event per group of two clouds', () {
    final top = CloudSpec(x: 400, lane: 0, groupId: 0);
    final mid = CloudSpec(x: 400, lane: 1, groupId: 0);
    // Skim just above the middle cloud while passing both clouds of the group.
    final y =
        mid.centreY -
        GameConfig.cloudHeight / 2 -
        3 -
        (GameConfig.planeHeight - GameConfig.planeHitboxInset);
    expect(CollisionRules.hits(y, [top..x = 150, mid..x = 150]), isFalse);
    expect(pass(NearMissTracker(), [top, mid], y), 1);
  });

  test('touching the cloud (a crash) never counts as a near miss', () {
    final c = CloudSpec(x: 400, lane: 1, groupId: 0);
    expect(pass(NearMissTracker(), [c], yBelow(c, -3)), 0);
  });

  test('reset forgets a partial close pass', () {
    final t = NearMissTracker();
    final c = CloudSpec(x: 160, lane: 1, groupId: 0);
    t.update(yBelow(c, 3), [c]); // close and level with the plane
    t.reset();
    // A new run reuses group id 0; passing it comfortably must not report
    // the old close reading.
    expect(pass(t, [CloudSpec(x: 400, lane: 1, groupId: 0)], yBelow(c, 25)), 0);
    t.reset();
    expect(pass(t, [CloudSpec(x: 400, lane: 1, groupId: 0)], yBelow(c, 3)), 1);
  });
}
