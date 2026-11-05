import 'dart:math';

import '../../core/game_config.dart';

/// Vertical motion of the plane. Positive velocity points downward.
class PlaneBody {
  PlaneBody() {
    reset();
  }

  double y = GameConfig.planeStartY;
  double velocity = 0;

  void reset() {
    y = GameConfig.planeStartY;
    velocity = 0;
  }

  void step(double dt) {
    velocity += GameConfig.gravity * dt;
    if (velocity > GameConfig.maxFallSpeed) {
      velocity = GameConfig.maxFallSpeed;
    }
    y += velocity * dt;
    // Soft ceiling: hold the hitbox top at the top edge and cancel any
    // upward speed, so the plane then falls instead of the run ending.
    if (y < ceilingY) {
      y = ceilingY;
      if (velocity < 0) velocity = 0;
    }
  }

  /// Lowest [y]: the hitbox bottom resting on the ground line.
  static const double groundY =
      GameConfig.groundTop -
      GameConfig.planeHeight +
      GameConfig.planeHitboxInset;

  bool get isResting => y >= groundY && velocity == 0;

  /// After a crash: falls under gravity until it rests on the ground, then
  /// stays there. Cosmetic only; no collisions are checked in game over.
  void fallToGround(double dt) {
    if (isResting) return;
    step(dt);
    if (y >= groundY) {
      y = groundY;
      velocity = 0;
    }
  }

  /// Highest allowed [y]: the hitbox top (inset from the drawn top) at 0.
  static const double ceilingY = -GameConfig.planeHitboxInset;

  /// Ready-state hover: places the plane on a gentle sine around its start
  /// height at [time] seconds, with no velocity. Gravity does not apply.
  void hover(double time) {
    y =
        GameConfig.planeStartY +
        GameConfig.hoverAmplitude * sin(2 * pi * time / GameConfig.hoverPeriod);
    velocity = 0;
  }

  /// Replaces the current vertical velocity with the upward impulse.
  void flap() {
    velocity = -GameConfig.flapImpulse;
  }
}
