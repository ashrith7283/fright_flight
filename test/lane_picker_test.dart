import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:fright_flight/core/game_config.dart';
import 'package:fright_flight/game/logic/lane_picker.dart';

void main() {
  shareTests();
  test('groups have 1 or 2 distinct lanes, never all three', () {
    final picker = LanePicker(Random(1));
    final sizes = <int>{};
    for (var i = 0; i < 2000; i++) {
      final lanes = picker.pick();
      sizes.add(lanes.length);
      expect(lanes.toSet().length, lanes.length);
      expect(lanes.length, lessThan(GameConfig.laneCount));
      expect(lanes.every((l) => l >= 0 && l < GameConfig.laneCount), isTrue);
    }
    expect(sizes, {1, 2});
  });

  test('lane choice varies between groups', () {
    final picker = LanePicker(Random(2));
    final seen = {for (var i = 0; i < 200; i++) picker.pick().join(',')};
    expect(seen.length, greaterThan(3));
  });
}

void shareTests() {
  double twoShare(double share) {
    final picker = LanePicker(Random(5));
    var two = 0;
    const n = 5000;
    for (var i = 0; i < n; i++) {
      final lanes = picker.pick(share);
      expect(lanes.length, lessThan(GameConfig.laneCount));
      if (lanes.length == 2) two++;
    }
    return two / n;
  }

  test('two-cloud share follows the given share', () {
    expect(twoShare(GameConfig.twoCloudShareBase), closeTo(0.5, 0.03));
    expect(twoShare(GameConfig.twoCloudShareMax), closeTo(0.8, 0.03));
  });
}
