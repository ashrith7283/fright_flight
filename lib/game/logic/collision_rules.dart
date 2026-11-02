import 'dart:ui';

import '../../core/game_config.dart';
import 'cloud_pair_spec.dart';

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

  static bool hitsBounds(double y) {
    final r = planeRect(y);
    return r.top <= 0 || r.bottom >= GameConfig.groundTop;
  }

  static bool hitsCloud(Rect plane, CloudPairSpec pair) {
    if (plane.right <= pair.x || plane.left >= pair.right) return false;
    return plane.top < pair.gapTop || plane.bottom > pair.gapBottom;
  }

  static bool hits(double y, Iterable<CloudPairSpec> pairs) {
    if (hitsBounds(y)) return true;
    final r = planeRect(y);
    return pairs.any((p) => hitsCloud(r, p));
  }
}
