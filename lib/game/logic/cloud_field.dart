import '../../core/game_config.dart';
import 'difficulty_curve.dart';
import 'cloud_spec.dart';
import 'lane_picker.dart';

/// Scrolls, spawns and removes cloud groups by distance travelled.
class CloudField {
  CloudField(this._picker);

  final LanePicker _picker;
  final List<CloudSpec> clouds = [];
  double _scrolled = 0;
  int _nextGroupId = 0;
  double? _lastSpawnAt; // distance at which the previous group spawned

  void reset() {
    clouds.clear();
    _scrolled = 0;
    _nextGroupId = 0;
    _lastSpawnAt = null;
  }

  /// Advances by [dt] at [speed] (the current scroll speed). [score] sets the
  /// spawn spacing, the two-cloud share and whether clouds may move (see
  /// [DifficultyCurve]); the gap before each group uses the spacing at the
  /// moment that group spawns, so groups already on screen never shift.
  /// Returns clouds spawned during this step.
  List<CloudSpec> step(
    double dt, {
    double speed = GameConfig.scrollSpeed,
    int score = 0,
  }) {
    final dx = speed * dt;
    _scrolled += dx;
    for (final c in clouds) {
      c.x -= dx;
      c.age += dt;
    }
    final spacing = DifficultyCurve.spacingFor(score);
    final spawned = <CloudSpec>[];
    while (true) {
      final last = _lastSpawnAt;
      final spawnAt = last == null
          ? GameConfig.firstGroupDistance
          : last + spacing;
      if (_scrolled < spawnAt) break;
      // Place exactly where the group would be had it spawned at the right
      // edge when the threshold was crossed, so spacing is dt-independent.
      final x = GameConfig.worldWidth - (_scrolled - spawnAt);
      spawned.addAll(_group(x, score));
      _lastSpawnAt = spawnAt;
    }
    clouds.addAll(spawned);
    clouds.removeWhere((c) => c.right < 0);
    return spawned;
  }

  List<CloudSpec> _group(double x, int score) {
    final groupId = _nextGroupId++;
    final lanes = _picker.pick(DifficultyCurve.twoCloudShare(score));
    // Only single clouds move, so two lanes stay free beside a moving cloud.
    final moving =
        lanes.length == 1 &&
        score >= GameConfig.movingCloudScore &&
        _picker.chance(GameConfig.movingCloudChance);
    return [
      for (final lane in lanes)
        CloudSpec(
          x: x,
          lane: lane,
          groupId: groupId,
          moving: moving,
          phase: moving ? _picker.phase() : 0,
        ),
    ];
  }
}
