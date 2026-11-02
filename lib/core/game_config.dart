import 'dart:ui';

/// Every tuning value for the gameplay loop. Distances are in world units,
/// speeds in units per second, accelerations in units per second².
class GameConfig {
  const GameConfig._();

  // World (fixed virtual resolution, landscape).
  static const double worldWidth = 800;
  static const double worldHeight = 400;
  static const double groundHeight = 50;
  static const double groundTop = worldHeight - groundHeight;

  static const Color skyColor = Color(0xFF8FD3F4);

  // Plane.
  static const double planeWidth = 48;
  static const double planeHeight = 30;
  static const double planeStartX = 150;
  static const double planeStartY = 160;
  static const double planeHitboxInset = 4;
  static const double gravity = 1300;
  static const double flapImpulse = 360; // upward speed set on each tap
  static const double maxFallSpeed = 600;

  // Clouds: ellipses centred in one of [laneCount] equal lanes.
  static const int laneCount = 3;
  static const double laneHeight = groundTop / laneCount;
  static const int maxCloudsPerGroup = 2; // must stay below laneCount
  static const double cloudWidth = 160;
  static const double cloudHeight = 52;
  static const double scrollSpeed = 220;
  static const double spawnSpacing = 460;
  static const double firstGroupDistance = 300;

  // Run lifecycle.
  static const double restartDelay = 0.6;
  static const double maxFrameDelta = 0.05;

  // Score text (world units, anchored top-left unless noted).
  static const Color scoreTextColor = Color(0xFFFFFFFF);
  static const double scoreFontSize = 32;
  static const double scoreTextX = 20;
  static const double scoreTextY = 12;
  static const double gameOverFontSize = 28;
  static const double gameOverTextX = worldWidth / 2; // centre-anchored
  static const double gameOverTextY = 110;
  static const double gameOverLineSpacing = 40;

  // Game-over buttons (Flutter overlay): top edge as a fraction of screen
  // height, placed below the game-over text (ends near world y 260 of 400).
  static const double gameOverActionsTopFraction = 0.7;
}
