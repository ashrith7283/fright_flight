import 'dart:ui';

import '../../core/game_config.dart';

/// Score medals, lowest first.
enum Medal {
  bronze('BRONZE', GameConfig.bronzeScore, Color(0xFFCD7F32)),
  silver('SILVER', GameConfig.silverScore, Color(0xFFC0C8D0)),
  gold('GOLD', GameConfig.goldScore, Color(0xFFFFD54F)),
  platinum('PLATINUM', GameConfig.platinumScore, Color(0xFFB3E5FC));

  const Medal(this.label, this.threshold, this.color);

  final String label;
  final int threshold;
  final Color color;
}

/// The next medal to aim for and the points still needed to reach it.
typedef MedalGoal = ({Medal medal, int pointsNeeded});

/// Medal rules as pure functions of a final score.
class Medals {
  const Medals._();

  /// The highest medal whose threshold [score] meets, or null below bronze.
  static Medal? forScore(int score) {
    Medal? best;
    for (final m in Medal.values) {
      if (score >= m.threshold) best = m;
    }
    return best;
  }

  /// The next higher medal after [score], or null once platinum is reached.
  static MedalGoal? next(int score) {
    for (final m in Medal.values) {
      if (score < m.threshold) {
        return (medal: m, pointsNeeded: m.threshold - score);
      }
    }
    return null;
  }
}
