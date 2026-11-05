import 'dart:math';

import '../../core/game_config.dart';

/// Chooses which lanes get a cloud in a group: one or two distinct lanes,
/// never all of them. Also supplies the other random choices of the cloud
/// field, so one seeded [Random] makes a whole run reproducible.
class LanePicker {
  LanePicker([Random? random]) : _random = random ?? Random();

  final Random _random;

  /// [twoCloudShare] is the chance (0..1) that the group has two clouds.
  List<int> pick([double twoCloudShare = GameConfig.twoCloudShareBase]) {
    assert(GameConfig.maxCloudsPerGroup < GameConfig.laneCount);
    final count = _random.nextDouble() < twoCloudShare
        ? GameConfig.maxCloudsPerGroup
        : 1;
    final lanes = List<int>.generate(GameConfig.laneCount, (i) => i)
      ..shuffle(_random);
    return lanes.take(count).toList()..sort();
  }

  /// True with probability [p].
  bool chance(double p) => _random.nextDouble() < p;

  /// A random phase in 0..2π.
  double phase() => _random.nextDouble() * 2 * pi;
}
