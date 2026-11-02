import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:fright_flight/core/game_config.dart';
import 'package:fright_flight/game/logic/cloud_spec.dart';
import 'package:fright_flight/game/logic/collision_rules.dart';

void main() {
  // Middle-lane cloud whose centre is level with the plane's centre column.
  final planeCentreX = GameConfig.planeStartX + GameConfig.planeWidth / 2;
  final centred = CloudSpec(
    x: planeCentreX - GameConfig.cloudWidth / 2,
    lane: 1,
  );

  test('ceiling and ground collide', () {
    expect(CollisionRules.hitsBounds(-GameConfig.planeHitboxInset), isTrue);
    expect(
      CollisionRules.hitsBounds(
        GameConfig.groundTop -
            GameConfig.planeHeight +
            GameConfig.planeHitboxInset,
      ),
      isTrue,
    );
    expect(CollisionRules.hitsBounds(GameConfig.planeStartY), isFalse);
  });

  test('direct hit on the ellipse', () {
    final y = centred.centreY - GameConfig.planeHeight / 2;
    expect(CollisionRules.hits(y, [centred]), isTrue);
  });

  test('flying over or under the cloud is safe', () {
    final h = GameConfig.cloudHeight / 2;
    final over = centred.centreY - h - GameConfig.planeHeight - 4;
    final under = centred.centreY + h + 4;
    expect(CollisionRules.hits(over, [centred]), isFalse);
    expect(CollisionRules.hits(under, [centred]), isFalse);
  });

  test('clipping only the bounding-box corner is not a hit', () {
    final plane = CollisionRules.planeRect(0);
    final b = centred.bounds;
    // Plane hitbox overlapping the cloud's top-left bbox corner by 2 units.
    final corner = Rect.fromLTRB(
      b.left - 20,
      b.top - 20,
      b.left + 2,
      b.top + 2,
    );
    expect(plane.width, greaterThan(0));
    expect(corner.overlaps(b), isTrue);
    final c = CloudSpec(x: corner.right - 2, lane: 1);
    expect(CollisionRules.hitsCloud(corner, c), isFalse);
  });

  test('cloud not overlapping horizontally is harmless', () {
    final far = CloudSpec(x: 700, lane: 1);
    expect(CollisionRules.hits(GameConfig.planeStartY, [far]), isFalse);
  });
}
