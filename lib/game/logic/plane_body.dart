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
  }

  /// Replaces the current vertical velocity with the upward impulse.
  void flap() {
    velocity = -GameConfig.flapImpulse;
  }
}
