import 'package:shared_preferences/shared_preferences.dart';

/// Persistence for the high score. Implementations may throw; callers decide
/// how to degrade (see ScoreKeeper).
abstract class StorageService {
  /// Returns null when nothing has been stored.
  Future<int?> readHighScore();
  Future<void> writeHighScore(int value);

  /// Returns null when nothing has been stored.
  Future<bool?> readMuted();
  Future<void> writeMuted(bool value);

  /// Returns null when nothing has been stored (vibration defaults to on).
  Future<bool?> readHaptics();
  Future<void> writeHaptics(bool value);
}

class SharedPreferencesStorageService implements StorageService {
  static const _highScoreKey = 'high_score';
  static const _mutedKey = 'muted';
  static const _hapticsKey = 'haptics';

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

  @override
  Future<bool?> readMuted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_mutedKey);
  }

  @override
  Future<void> writeMuted(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_mutedKey, value);
  }

  @override
  Future<bool?> readHaptics() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hapticsKey);
  }

  @override
  Future<void> writeHaptics(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hapticsKey, value);
  }
}
