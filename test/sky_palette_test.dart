import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:fright_flight/core/game_config.dart';
import 'package:fright_flight/game/logic/sky_palette.dart';

double _dist(Color a, Color b) =>
    (a.r - b.r).abs() + (a.g - b.g).abs() + (a.b - b.b).abs();

void main() {
  test('score 0 and below is the day palette', () {
    expect(SkyPalette.at(0).top, SkyPalette.day.top);
    expect(SkyPalette.at(-5).sunY, GameConfig.sunDayY);
  });

  test('sunset stop reaches the sunset palette', () {
    final s = SkyPalette.at(GameConfig.skySunsetScore);
    expect(s.top, SkyPalette.sunset.top);
    expect(s.sunY, GameConfig.sunSunsetY);
  });

  test('between day and dusk the sky is between the palettes', () {
    final s = SkyPalette.at(GameConfig.skySunsetScore ~/ 2);
    expect(s.sunY, greaterThan(GameConfig.sunDayY));
    expect(s.sunY, lessThan(GameConfig.sunSunsetY));
    expect(s.top, isNot(SkyPalette.day.top));
  });

  test('dusk is the limit', () {
    expect(SkyPalette.at(GameConfig.skyDuskScore).top, SkyPalette.dusk.top);
    expect(SkyPalette.at(100000).bottom, SkyPalette.dusk.bottom);
    expect(SkyPalette.at(100000).sunY, GameConfig.sunDuskY);
  });

  test('one point never jumps the colours', () {
    for (var s = 0; s < GameConfig.skyDuskScore + 5; s++) {
      final a = SkyPalette.at(s), b = SkyPalette.at(s + 1);
      expect(_dist(a.top, b.top), lessThan(0.25));
      expect(_dist(a.bottom, b.bottom), lessThan(0.25));
      expect((a.sunY - b.sunY).abs(), lessThan(15));
    }
  });

  test('dusk top stays clearly lighter than black for contrast', () {
    final t = SkyPalette.dusk.top;
    expect(t.r + t.g + t.b, greaterThan(0.45));
  });
}
