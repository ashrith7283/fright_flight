import '../../core/game_config.dart';
import '../../services/storage_service.dart';
import 'cloud_spec.dart';

/// Score, high score and persistence rules. Plain Dart, no Flame.
class ScoreKeeper {
  ScoreKeeper(this._storage);

  final StorageService _storage;

  int score = 0;
  int highScore = 0;

  /// True when the finished run beat the high score held before it.
  bool newBest = false;

  int _lastCountedGroupId = -1;
  bool _finished = false;

  /// Loads the stored high score. Missing, negative or failing reads give 0.
  Future<void> load() async {
    try {
      final stored = await _storage.readHighScore();
      highScore = (stored == null || stored < 0) ? 0 : stored;
    } catch (_) {
      highScore = 0;
    }
  }

  /// Awards 1 per group whose trailing edge is now left of the plane's
  /// trailing edge. Groups pass in id order, so a watermark is enough.
  /// Returns the points awarded.
  int onCloudsAdvanced(Iterable<CloudSpec> clouds) {
    if (_finished) return 0;
    final passed = <int>{
      for (final c in clouds)
        if (c.groupId > _lastCountedGroupId && c.right < GameConfig.planeStartX)
          c.groupId,
    };
    if (passed.isEmpty) return 0;
    _lastCountedGroupId = passed.reduce((a, b) => a > b ? a : b);
    score += passed.length;
    return passed.length;
  }

  /// Ends the run. Saves once, and only if the high score was beaten.
  /// The in-memory value is updated first and kept if the write fails.
  Future<void> finishRun() async {
    if (_finished) return;
    _finished = true;
    if (score <= highScore) return;
    highScore = score;
    newBest = true;
    try {
      await _storage.writeHighScore(highScore);
    } catch (_) {
      // Storage failures must never interrupt play; retried at next new best.
    }
  }

  /// Prepares a new run. The high score is kept.
  void reset() {
    score = 0;
    newBest = false;
    _lastCountedGroupId = -1;
    _finished = false;
  }
}
