import 'dart:math';
import 'dart:ui';

import '../../core/game_config.dart';
import 'cloud_spec.dart';

class CollisionRules {
  const CollisionRules._();

  /// Plane hitbox at vertical position [y] (top edge), shrunk by the inset.
  static Rect planeRect(double y) {
    const inset = GameConfig.planeHitboxInset;
    return Rect.fromLTWH(
      GameConfig.planeStartX + inset,
      y + inset,
      GameConfig.planeWidth - 2 * inset,
      GameConfig.planeHeight - 2 * inset,
    );
  }

  /// Only the ground ends a run; the ceiling is handled by [PlaneBody].
  static bool hitsBounds(double y) =>
      planeRect(y).bottom >= GameConfig.groundTop;

  /// Exact rectangle vs ellipse test: take the point of the rectangle nearest
  /// the ellipse centre and check it lies inside the ellipse equation.
  static bool hitsCloud(Rect plane, CloudSpec cloud) =>
      proximity(plane, cloud) < 1;

  /// The ellipse equation's value at the point of [plane] nearest the cloud
  /// centre: below 1 is inside (a hit), 1 is touching, larger is farther.
  static double proximity(Rect plane, CloudSpec cloud) {
    final nx = cloud.centreX.clamp(plane.left, plane.right);
    final ny = cloud.centreY.clamp(plane.top, plane.bottom);
    final dx = (nx - cloud.centreX) / (GameConfig.cloudWidth / 2);
    final dy = (ny - cloud.centreY) / (GameConfig.cloudHeight / 2);
    return pow(dx, 2) + pow(dy, 2).toDouble();
  }

  static bool hits(double y, Iterable<CloudSpec> clouds) {
    if (hitsBounds(y)) return true;
    final r = planeRect(y);
    return clouds.any((c) => hitsCloud(r, c));
  }
}
