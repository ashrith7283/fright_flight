import 'package:flutter_test/flutter_test.dart';
import 'package:fright_flight/core/game_config.dart';
import 'package:fright_flight/game/logic/cloud_pair_spec.dart';
import 'package:fright_flight/game/logic/collision_rules.dart';

void main() {
  final overlapX = GameConfig.planeStartX;

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

  test('passes through the gap', () {
    final pair = CloudPairSpec(x: overlapX - 10, gapCentre: 380);
    expect(CollisionRules.hits(360, [pair]), isFalse);
  });

  test('hits top and bottom clouds', () {
    final high = CloudPairSpec(x: overlapX - 10, gapCentre: 500);
    final low = CloudPairSpec(x: overlapX - 10, gapCentre: 200);
    expect(CollisionRules.hits(360, [high]), isTrue);
    expect(CollisionRules.hits(360, [low]), isTrue);
  });

  test('cloud not overlapping horizontally is harmless', () {
    final far = CloudPairSpec(x: 350, gapCentre: 500);
    expect(CollisionRules.hits(360, [far]), isFalse);
  });
}
