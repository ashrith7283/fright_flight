import 'dart:math';

import '../../core/game_config.dart';

class GapGenerator {
  GapGenerator([Random? random]) : _random = random ?? Random();

  final Random _random;

  /// Next gap centre, within the margins and within `maxGapShift` of
  /// [previousCentre] (if any).
  double next([double? previousCentre]) {
    const half = GameConfig.gapSize / 2;
    var min = GameConfig.ceilingMargin + half;
    var max = GameConfig.groundTop - GameConfig.groundMargin - half;
    if (previousCentre != null) {
      if (previousCentre - GameConfig.maxGapShift > min) {
        min = previousCentre - GameConfig.maxGapShift;
      }
      if (previousCentre + GameConfig.maxGapShift < max) {
        max = previousCentre + GameConfig.maxGapShift;
      }
    }
    return min + _random.nextDouble() * (max - min);
  }
}
