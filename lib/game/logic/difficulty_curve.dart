import 'dart:math';

import '../../core/game_config.dart';

/// Difficulty as a function of score. Speed, spawn spacing and the share of
/// two-cloud groups all ease linearly from their base at score 0 to their
/// limit at [GameConfig.rampEndScore], then hold.
class DifficultyCurve {
  const DifficultyCurve._();

  /// Ramp progress in 0..1.
  static double _t(int score) =>
      min(max(score, 0), GameConfig.rampEndScore) / GameConfig.rampEndScore;

  static double _lerp(double a, double b, int score) => a + (b - a) * _t(score);

  static double speedFor(int score) =>
      _lerp(GameConfig.scrollSpeed, GameConfig.maxScrollSpeed, score);

  static double spacingFor(int score) =>
      _lerp(GameConfig.spawnSpacing, GameConfig.minSpawnSpacing, score);

  static double twoCloudShare(int score) =>
      _lerp(GameConfig.twoCloudShareBase, GameConfig.twoCloudShareMax, score);
}
