import 'dart:math';

import '../../core/game_config.dart';

/// Chooses which lanes get a cloud in a group: 1 to `maxCloudsPerGroup`
/// distinct lanes, never all of them.
class LanePicker {
  LanePicker([Random? random]) : _random = random ?? Random();

  final Random _random;

  List<int> pick() {
    assert(GameConfig.maxCloudsPerGroup < GameConfig.laneCount);
    final count = 1 + _random.nextInt(GameConfig.maxCloudsPerGroup);
    final lanes = List<int>.generate(GameConfig.laneCount, (i) => i)
      ..shuffle(_random);
    return lanes.take(count).toList()..sort();
  }
}
