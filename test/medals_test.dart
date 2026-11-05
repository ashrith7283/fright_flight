import 'package:flutter_test/flutter_test.dart';
import 'package:fright_flight/core/game_config.dart';
import 'package:fright_flight/game/logic/medals.dart';

void main() {
  test('no medal below bronze', () {
    expect(Medals.forScore(0), isNull);
    expect(Medals.forScore(GameConfig.bronzeScore - 1), isNull);
  });

  test('exact thresholds earn that medal', () {
    for (final m in Medal.values) {
      expect(Medals.forScore(m.threshold), m);
      if (m.index > 0) {
        expect(Medals.forScore(m.threshold - 1), Medal.values[m.index - 1]);
      }
    }
  });

  test('above the top threshold is still platinum', () {
    expect(Medals.forScore(GameConfig.platinumScore * 10), Medal.platinum);
  });

  test('next medal and points needed for each band', () {
    const b = GameConfig.bronzeScore, s = GameConfig.silverScore;
    const g = GameConfig.goldScore, p = GameConfig.platinumScore;
    expect(Medals.next(0), (medal: Medal.bronze, pointsNeeded: b));
    expect(Medals.next(b - 1), (medal: Medal.bronze, pointsNeeded: 1));
    expect(Medals.next(b), (medal: Medal.silver, pointsNeeded: s - b));
    expect(Medals.next(s + 1), (medal: Medal.gold, pointsNeeded: g - s - 1));
    expect(Medals.next(p - 1), (medal: Medal.platinum, pointsNeeded: 1));
    expect(Medals.next(p), isNull);
    expect(Medals.next(p * 5), isNull);
  });

  test('thresholds rise strictly', () {
    for (var i = 1; i < Medal.values.length; i++) {
      expect(
        Medal.values[i].threshold,
        greaterThan(Medal.values[i - 1].threshold),
      );
    }
  });
}
