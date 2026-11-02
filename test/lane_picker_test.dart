import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:fright_flight/core/game_config.dart';
import 'package:fright_flight/game/logic/lane_picker.dart';

void main() {
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
