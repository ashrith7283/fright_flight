import 'dart:ui';

/// Every tuning value for the core gameplay loop. Distances are in world
/// units, speeds in units per second, accelerations in units per second².
class GameConfig {
  const GameConfig._();

  // World (fixed virtual resolution, portrait).
  static const double worldWidth = 400;
  static const double worldHeight = 800;
  static const double groundHeight = 100;
  static const double groundTop = worldHeight - groundHeight;

  static const Color skyColor = Color(0xFF8FD3F4);

  // Plane.
  static const double planeWidth = 56;
  static const double planeHeight = 36;
  static const double planeStartX = 100;
  static const double planeStartY = 360;
  static const double planeHitboxInset = 4;
  static const double gravity = 1500;
  static const double flapImpulse = 480; // upward speed set on each tap
  static const double maxFallSpeed = 700;

  // Clouds.
  static const double scrollSpeed = 160;
  static const double cloudWidth = 90;
  static const double gapSize = 220;
  static const double ceilingMargin = 60;
  static const double groundMargin = 60;
  static const double maxGapShift = 140;
  static const double spawnSpacing = 280;
  static const double firstPairDistance = 240;

  // Run lifecycle.
  static const double restartDelay = 0.6;
  static const double maxFrameDelta = 0.05;
}
