import 'dart:math';

import '../../core/game_config.dart';

/// Scroll speed as a function of score: starts at the base speed, rises by a
/// fixed amount per point and is capped. Spawn spacing is not changed.
class DifficultyCurve {
  const DifficultyCurve._();

  static double speedFor(int score) => min(
    GameConfig.scrollSpeed + GameConfig.scrollSpeedPerPoint * max(score, 0),
    GameConfig.maxScrollSpeed,
  );
}
