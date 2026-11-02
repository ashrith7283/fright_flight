import 'package:flutter_test/flutter_test.dart';
import 'package:fright_flight/core/game_config.dart';
import 'package:fright_flight/game/logic/plane_body.dart';

void main() {
  test('falls with increasing speed', () {
    final p = PlaneBody();
    p.step(0.1);
    final v1 = p.velocity;
    p.step(0.1);
    expect(v1, greaterThan(0));
    expect(p.velocity, greaterThan(v1));
    expect(p.y, greaterThan(GameConfig.planeStartY));
  });

  test('fall speed is capped', () {
    final p = PlaneBody();
    for (var i = 0; i < 200; i++) {
      p.step(0.016);
    }
    expect(p.velocity, GameConfig.maxFallSpeed);
  });

  test('flap replaces velocity and moves up', () {
    final p = PlaneBody();
    for (var i = 0; i < 30; i++) {
      p.step(0.016);
    }
    p.flap();
    expect(p.velocity, -GameConfig.flapImpulse);
    final y = p.y;
    p.step(0.016);
    expect(p.y, lessThan(y));
  });

  test('repeated taps do not stack', () {
    final p = PlaneBody();
    p.flap();
    p.flap();
    p.flap();
    expect(p.velocity, -GameConfig.flapImpulse);
  });
}
