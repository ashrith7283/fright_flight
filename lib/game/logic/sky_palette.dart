import 'dart:ui';

import '../../core/game_config.dart';

/// Sky colours and sun for one moment of the day. Cosmetic only.
class SkyState {
  const SkyState({
    required this.top,
    required this.bottom,
    required this.sunColor,
    required this.sunY,
  });

  final Color top;
  final Color bottom;
  final Color sunColor;
  final double sunY;

  static SkyState lerp(SkyState a, SkyState b, double t) => SkyState(
    top: Color.lerp(a.top, b.top, t)!,
    bottom: Color.lerp(a.bottom, b.bottom, t)!,
    sunColor: Color.lerp(a.sunColor, b.sunColor, t)!,
    sunY: a.sunY + (b.sunY - a.sunY) * t,
  );
}

/// Day -> sunset -> dusk as the score rises; dusk is the limit.
class SkyPalette {
  const SkyPalette._();

  static const day = SkyState(
    top: GameConfig.skyTopColor,
    bottom: GameConfig.skyBottomColor,
    sunColor: GameConfig.sunColor,
    sunY: GameConfig.sunDayY,
  );
  static const sunset = SkyState(
    top: GameConfig.skySunsetTop,
    bottom: GameConfig.skySunsetBottom,
    sunColor: GameConfig.sunSunsetColor,
    sunY: GameConfig.sunSunsetY,
  );
  static const dusk = SkyState(
    top: GameConfig.skyDuskTop,
    bottom: GameConfig.skyDuskBottom,
    sunColor: GameConfig.sunDuskColor,
    sunY: GameConfig.sunDuskY,
  );

  static SkyState at(int score) {
    if (score <= 0) return day;
    if (score >= GameConfig.skyDuskScore) return dusk;
    if (score <= GameConfig.skySunsetScore) {
      return SkyState.lerp(day, sunset, score / GameConfig.skySunsetScore);
    }
    final span = GameConfig.skyDuskScore - GameConfig.skySunsetScore;
    return SkyState.lerp(
      sunset,
      dusk,
      (score - GameConfig.skySunsetScore) / span,
    );
  }
}
