import '../../core/game_config.dart';
import 'cloud_spec.dart';
import 'lane_picker.dart';

/// Scrolls, spawns and removes cloud groups by distance travelled.
class CloudField {
  CloudField(this._picker);

  final LanePicker _picker;
  final List<CloudSpec> clouds = [];
  double _scrolled = 0;
  double _nextSpawnAt = GameConfig.firstGroupDistance;

  void reset() {
    clouds.clear();
    _scrolled = 0;
    _nextSpawnAt = GameConfig.firstGroupDistance;
  }

  /// Advances by [dt]. Returns clouds spawned during this step.
  List<CloudSpec> step(double dt) {
    final dx = GameConfig.scrollSpeed * dt;
    _scrolled += dx;
    for (final c in clouds) {
      c.x -= dx;
    }
    final spawned = <CloudSpec>[];
    while (_scrolled >= _nextSpawnAt) {
      // Place exactly where the group would be had it spawned at the right
      // edge when the threshold was crossed, so spacing is dt-independent.
      final x = GameConfig.worldWidth - (_scrolled - _nextSpawnAt);
      for (final lane in _picker.pick()) {
        spawned.add(CloudSpec(x: x, lane: lane));
      }
      _nextSpawnAt += GameConfig.spawnSpacing;
    }
    clouds.addAll(spawned);
    clouds.removeWhere((c) => c.right < 0);
    return spawned;
  }
}
