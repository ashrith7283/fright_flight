import '../../core/game_config.dart';
import 'cloud_pair_spec.dart';
import 'gap_generator.dart';

/// Scrolls, spawns and removes cloud pairs by distance travelled.
class CloudField {
  CloudField(this._generator);

  final GapGenerator _generator;
  final List<CloudPairSpec> pairs = [];
  double _scrolled = 0;
  double _nextSpawnAt = GameConfig.firstPairDistance;
  double? _lastCentre;

  void reset() {
    pairs.clear();
    _scrolled = 0;
    _nextSpawnAt = GameConfig.firstPairDistance;
    _lastCentre = null;
  }

  /// Advances by [dt]. Returns pairs spawned during this step.
  List<CloudPairSpec> step(double dt) {
    final dx = GameConfig.scrollSpeed * dt;
    _scrolled += dx;
    for (final p in pairs) {
      p.x -= dx;
    }
    final spawned = <CloudPairSpec>[];
    while (_scrolled >= _nextSpawnAt) {
      final centre = _generator.next(_lastCentre);
      _lastCentre = centre;
      // Place exactly where it would be had it spawned at the right edge
      // when the threshold was crossed, so spacing is dt-independent.
      final pair = CloudPairSpec(
        x: GameConfig.worldWidth - (_scrolled - _nextSpawnAt),
        gapCentre: centre,
      );
      pairs.add(pair);
      spawned.add(pair);
      _nextSpawnAt += GameConfig.spawnSpacing;
    }
    pairs.removeWhere((p) => p.right < 0);
    return spawned;
  }
}
