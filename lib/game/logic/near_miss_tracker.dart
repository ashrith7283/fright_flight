import '../../core/game_config.dart';
import 'cloud_spec.dart';
import 'collision_rules.dart';

/// Detects close passes: while a group's clouds are level with the plane it
/// keeps the closest [CollisionRules.proximity] seen, and when the group is
/// passed (same rule as scoring) it reports a near miss if that was within
/// [GameConfig.nearMissMargin]. Cosmetic only; never changes the score.
class NearMissTracker {
  final Map<int, double> _closest = {};
  int _lastPassedGroup = -1;

  /// Call once per playing update in which the plane did not crash.
  /// Returns how many groups were just passed as near misses.
  int update(double planeY, Iterable<CloudSpec> clouds) {
    final plane = CollisionRules.planeRect(planeY);
    final passed = <int>{};
    for (final c in clouds) {
      if (c.groupId <= _lastPassedGroup) continue;
      if (c.x < plane.right && c.right > plane.left) {
        final p = CollisionRules.proximity(plane, c);
        final old = _closest[c.groupId];
        if (old == null || p < old) _closest[c.groupId] = p;
      }
      if (c.right < GameConfig.planeStartX) passed.add(c.groupId);
    }
    var events = 0;
    for (final id in passed) {
      final closest = _closest.remove(id);
      // At or below 1 the plane touched the cloud: that is a crash, not a miss.
      if (closest != null &&
          closest > 1 &&
          closest < GameConfig.nearMissMargin) {
        events++;
      }
      if (id > _lastPassedGroup) _lastPassedGroup = id;
    }
    return events;
  }

  void reset() {
    _closest.clear();
    _lastPassedGroup = -1;
  }
}
