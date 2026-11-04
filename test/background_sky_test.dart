import 'package:flutter_test/flutter_test.dart';
import 'package:fright_flight/core/game_config.dart';
import 'package:fright_flight/game/components/background_component.dart';
import 'package:fright_flight/game/logic/sky_palette.dart';

void main() {
  test('sky eases to dusk as the score rises and back to day on restart', () {
    var score = 0;
    final bg = BackgroundComponent(score: () => score);
    expect(bg.sky.top, SkyPalette.day.top);

    score = GameConfig.skyDuskScore + 10;
    bg.update(0.016);
    // One small step: moved, but nowhere near dusk yet (no jump).
    expect(bg.sky.top, isNot(SkyPalette.day.top));
    expect(bg.sky.top, isNot(SkyPalette.dusk.top));

    for (var i = 0; i < 600; i++) {
      bg.update(0.016);
    }
    expect(bg.sky.sunY, closeTo(GameConfig.sunDuskY, 1));

    score = 0; // restart
    for (var i = 0; i < 600; i++) {
      bg.update(0.016);
    }
    expect(bg.sky.sunY, closeTo(GameConfig.sunDayY, 1));
  });
}
