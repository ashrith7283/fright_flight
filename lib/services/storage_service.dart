import 'package:shared_preferences/shared_preferences.dart';

/// Persistence for the high score. Implementations may throw; callers decide
/// how to degrade (see ScoreKeeper).
abstract class StorageService {
  /// Returns null when nothing has been stored.
  Future<int?> readHighScore();
  Future<void> writeHighScore(int value);
}

class SharedPreferencesStorageService implements StorageService {
  static const _highScoreKey = 'high_score';

  // Fetched per call (the instance is cached by the plugin) so a failing
  // lookup is an ordinary exception, not a launch crash.
  @override
  Future<int?> readHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_highScoreKey); // throws on a wrong-typed value
  }

  @override
  Future<void> writeHighScore(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_highScoreKey, value);
  }
}
