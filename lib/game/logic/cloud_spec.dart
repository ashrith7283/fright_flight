import 'dart:math';
import 'dart:ui';

import '../../core/game_config.dart';

/// One elliptical cloud, centred vertically in its lane. A moving cloud
/// drifts up and down around the lane centre as its [age] advances.
class CloudSpec {
  CloudSpec({
    required this.x,
    required this.lane,
    required this.groupId,
    this.moving = false,
    this.phase = 0,
  });

  /// Left edge of the cloud's bounding box.
  double x;
  final int lane;

  /// Shared by every cloud of one group; increases in spawn order.
  final int groupId;

  final bool moving;

  /// Starting point of the drift cycle, in radians.
  final double phase;

  /// Seconds this cloud has existed in a running game; frozen when the field
  /// is not stepped (paused, game over).
  double age = 0;

  double get laneCentreY => (lane + 0.5) * GameConfig.laneHeight;

  double get centreY {
    if (!moving) return laneCentreY;
    final angle = phase + 2 * pi * age / GameConfig.movingCloudPeriod;
    return laneCentreY + GameConfig.movingCloudAmplitude * sin(angle);
  }

  double get centreX => x + GameConfig.cloudWidth / 2;
  double get right => x + GameConfig.cloudWidth;

  Rect get bounds => Rect.fromLTWH(
    x,
    centreY - GameConfig.cloudHeight / 2,
    GameConfig.cloudWidth,
    GameConfig.cloudHeight,
  );
}
