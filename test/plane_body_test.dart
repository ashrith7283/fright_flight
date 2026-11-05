import 'package:flutter_test/flutter_test.dart';
import 'package:fright_flight/core/game_config.dart';
import 'package:fright_flight/game/logic/plane_body.dart';

void main() {
  fallTests();
  hoverTests();
  ceilingTests();
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

void ceilingTests() {
  test('the ceiling holds the plane and cancels upward speed', () {
    final p = PlaneBody();
    for (var i = 0; i < 120; i++) {
      p.flap();
      p.step(1 / 60);
      expect(p.y, greaterThanOrEqualTo(PlaneBody.ceilingY));
    }
    expect(p.y, PlaneBody.ceilingY);
    expect(p.velocity, greaterThanOrEqualTo(0));
  });

  test('after touching the ceiling the plane falls again', () {
    final p = PlaneBody()..y = PlaneBody.ceilingY + 1;
    p.flap();
    p.step(1 / 60);
    expect(p.y, PlaneBody.ceilingY);
    for (var i = 0; i < 20; i++) {
      p.step(1 / 60);
    }
    expect(p.y, greaterThan(PlaneBody.ceilingY));
  });
}

void hoverTests() {
  test('hover stays within the amplitude and has no velocity', () {
    final p = PlaneBody();
    var moved = false;
    for (var i = 0; i < 200; i++) {
      p.hover(i / 60);
      expect(
        (p.y - GameConfig.planeStartY).abs(),
        lessThanOrEqualTo(GameConfig.hoverAmplitude + 1e-9),
      );
      expect(p.velocity, 0);
      if (p.y != GameConfig.planeStartY) moved = true;
    }
    expect(moved, isTrue);
  });

  test('a flap after hovering starts from the current height', () {
    final p = PlaneBody()..hover(GameConfig.hoverPeriod / 4); // highest offset
    final y = p.y;
    expect(y, isNot(GameConfig.planeStartY));
    p.flap();
    p.step(1 / 60);
    expect(p.y, lessThan(y));
    expect(p.y, greaterThan(y - GameConfig.flapImpulse / 60 - 1e-9));
  });
}

void fallTests() {
  test('after a crash the plane falls and then rests on the ground', () {
    final p = PlaneBody()..y = 100;
    var last = p.y;
    var steps = 0;
    while (!p.isResting) {
      p.fallToGround(1 / 60);
      expect(p.y, greaterThanOrEqualTo(last));
      expect(p.y, lessThanOrEqualTo(PlaneBody.groundY));
      last = p.y;
      expect(++steps, lessThan(600));
    }
    expect(p.y, PlaneBody.groundY);
    p.fallToGround(1 / 60);
    expect(p.y, PlaneBody.groundY);
    expect(p.velocity, 0);
  });
}
