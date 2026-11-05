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

  // Visual style (cosmetic only; never affects collisions).
  static const Color skyTopColor = Color(0xFF3E9BE0);
  static const Color skyBottomColor = Color(0xFFCDEBFA);
  static const Color sunColor = Color(0xFFFFE680);
  static const Color hillFarColor = Color(0xFF7FB069);
  static const Color hillNearColor = Color(0xFF5E9A3C);
  static const Color groundColor = Color(0xFF4F8A2E);
  static const Color groundDarkColor = Color(0xFF3F7424);
  static const Color cloudColor = Color(0xFFFFFFFF);
  static const Color cloudShadeColor = Color(0xFFD5E3EE);
  static const Color planeBodyColor = Color(0xFFD32F2F);
  static const Color planeWingColor = Color(0xFFB71C1C);
  static const Color planeWindowColor = Color(0xFF81D4FA);
  static const double planeMaxTilt = 0.22; // radians
  static const double planeTiltEaseRate = 10; // per second
  static const double propellerSpinRate = 40; // radians per second
  static const double bgHillParallax = 0.4;

  // Sky progression by score: day -> sunset -> dusk (cosmetic).
  static const int skySunsetScore = 15;
  static const int skyDuskScore = 35;
  static const double skyEaseRate = 1.5; // per second towards the target
  static const Color skySunsetTop = Color(0xFF5C6BC0);
  static const Color skySunsetBottom = Color(0xFFFFB27A);
  static const Color skyDuskTop = Color(0xFF283A7A);
  static const Color skyDuskBottom = Color(0xFF9575B0);
  static const Color sunSunsetColor = Color(0xFFFFA24D);
  static const Color sunDuskColor = Color(0xFFFF7043);
  static const double sunX = 680;
  static const double sunDayY = 70;
  static const double sunSunsetY = 190;
  static const double sunDuskY = 245;

  // Extra parallax layers (fractions of the base scroll speed).
  static const double bgMountainParallax = 0.12;
  static const Color mountainColor = Color(0xFF6F8FB0);

  // Shared UI look.
  static const Color uiAccent = Color(0xFFE53935);
  static const Color uiGlassFill = Color(0x6620364F);
  static const Color uiGlassBorder = Color(0x80FFFFFF);
  static const double uiGlassBlur = 12;
  static const double uiRadius = 24;
  static const Duration uiAnimation = Duration(milliseconds: 220);

  // Smoke trail (cosmetic).
  static const double smokeSpawnInterval = 0.1;
  static const double smokeLifetime = 0.8;
  static const double smokeStartRadius = 3;
  static const double smokeEndRadius = 9;
  static const double smokeStartAlpha = 0.55;
  static const Color smokeColor = Color(0xFFEEEEEE);

  // Birds (cosmetic): x, y, speed (units/s), flap phase. Small, dark, high up.
  static const List<List<double>> birds = [
    [120, 40, 26, 0.0],
    [330, 85, 34, 1.7],
    [470, 28, 22, 3.1],
    [610, 120, 30, 4.6],
  ];
  static const double birdWingspan = 18;
  static const double birdFlapRate = 9; // radians per second
  static const Color birdColor = Color(0xFF263238);

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
  static const double firstGroupDistance = 300;

  // Difficulty ramp: everything below eases from its base at score 0 to its
  // limit at [rampEndScore], then holds.
  static const int rampEndScore = 60;
  static const double scrollSpeed = 220; // base speed at score 0
  static const double maxScrollSpeed = 300;
  static const double scrollSpeedPerPoint =
      (maxScrollSpeed - scrollSpeed) / rampEndScore;
  static const double spawnSpacing = 460; // base spacing at score 0
  static const double minSpawnSpacing = 440;
  static const double spawnSpacingPerPoint =
      (spawnSpacing - minSpawnSpacing) / rampEndScore;
  static const double twoCloudShareBase = 0.5;
  static const double twoCloudShareMax = 0.8;

  // Moving clouds: single-cloud groups may drift within their lane.
  static const int movingCloudScore = 50;
  static const double movingCloudChance = 0.35;
  static const double movingCloudAmplitude = 18;
  static const double movingCloudPeriod = 2.4; // seconds

  // Ready state: the plane hovers around its start position.
  static const double hoverAmplitude = 6;
  static const double hoverPeriod = 1.6; // seconds

  // "TAP TO FLY" prompt in the ready state, centred under the plane.
  static const double promptX = planeStartX + planeWidth / 2;
  static const double promptY = planeStartY + planeHeight + 30;
  static const double promptFontSize = 22;
  static const double promptPulsePeriod = 1.2; // seconds
  static const double promptMinAlpha = 0.35;

  // Game feel (cosmetic only; never affects collisions, score or timing).
  static const double scorePopScale = 1.35;
  static const double scorePopDuration = 0.25; // seconds
  static const double crashShakeAmplitude = 6;
  static const double crashShakeDuration = 0.35; // seconds
  static const double crashFlashAlpha = 0.6;
  static const double crashFlashDuration = 0.2; // seconds
  static const double nearMissMargin =
      1.6; // normalised ellipse value; 1 = touching
  static const double nearMissLabelDuration = 0.6; // seconds
  static const double nearMissLabelRise = 30; // world units over its lifetime

  // Medals: minimum final score for each tier.
  static const int bronzeScore = 10;
  static const int silverScore = 25;
  static const int goldScore = 50;
  static const int platinumScore = 100;

  // Loading screen: minimum time shown at cold start.
  static const Duration loadingMinDuration = Duration(milliseconds: 1200);

  // Run lifecycle.
  static const double restartDelay = 0.6;
  static const double maxFrameDelta = 0.05;

  // Score text (world units, anchored top-left unless noted).
  static const Color scoreTextColor = Color(0xFFFFFFFF);
  static const double scoreFontSize = 32;
  static const double scoreTextX = 20;
  static const double scoreTextY = 12;
  static const double bestFontSize = 18;
  static const double bestTextY = scoreTextY + scoreFontSize + 6;
}
