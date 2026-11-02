import 'dart:ui';

import '../../core/game_config.dart';

/// One elliptical cloud, centred vertically in its lane.
class CloudSpec {
  CloudSpec({required this.x, required this.lane, required this.groupId});

  /// Left edge of the cloud's bounding box.
  double x;
  final int lane;

  /// Shared by every cloud of one group; increases in spawn order.
  final int groupId;

  double get centreY => (lane + 0.5) * GameConfig.laneHeight;
  double get centreX => x + GameConfig.cloudWidth / 2;
  double get right => x + GameConfig.cloudWidth;

  Rect get bounds => Rect.fromLTWH(
    x,
    centreY - GameConfig.cloudHeight / 2,
    GameConfig.cloudWidth,
    GameConfig.cloudHeight,
  );
}
