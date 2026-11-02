import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:fright_flight/core/game_config.dart';
import 'package:fright_flight/game/logic/cloud_field.dart';
import 'package:fright_flight/game/logic/lane_picker.dart';

CloudField make() => CloudField(LanePicker(Random(3)));

void main() {
  groupIdTests();
  test('no clouds before first-group distance', () {
    final f = make();
    f.step((GameConfig.firstGroupDistance - 1) / GameConfig.scrollSpeed);
    expect(f.clouds, isEmpty);
  });

  test('spacing between live groups equals spawnSpacing', () {
    for (final dt in [1 / 60, 0.4]) {
      final f = make();
      for (var t = 0.0; t < 8; t += dt) {
        f.step(dt);
      }
      final xs = f.clouds.map((c) => c.x).toSet().toList()..sort();
      expect(xs.length, greaterThan(1));
      for (var i = 1; i < xs.length; i++) {
        expect(xs[i] - xs[i - 1], closeTo(GameConfig.spawnSpacing, 1e-6));
      }
    }
  });

  test('clouds sit in three distinct lane centres', () {
    final f = make();
    final centres = <double>{};
    for (var i = 0; i < 3000; i++) {
      f.step(1 / 60);
      centres.addAll(f.clouds.map((c) => c.centreY));
    }
    expect(centres.length, GameConfig.laneCount);
    for (var i = 0; i < GameConfig.laneCount; i++) {
      expect(centres, contains((i + 0.5) * GameConfig.laneHeight));
    }
  });

  test('clouds are removed after leaving the left edge', () {
    final f = make();
    for (var i = 0; i < 1200; i++) {
      f.step(1 / 60);
    }
    expect(f.clouds.every((c) => c.right >= 0), isTrue);
    expect(f.clouds.length, lessThan(8));
  });

  test('scroll is dt-independent', () {
    final a = make(), b = make();
    for (var i = 0; i < 306; i++) {
      a.step(1 / 60);
    }
    b.step(306 / 60);
    expect(a.clouds.last.x, closeTo(b.clouds.last.x, 1e-6));
  });
}

void groupIdTests() {
  test('clouds of a group share an id; groups have distinct ids', () {
    final f = make();
    final byId = <int, List<double>>{};
    for (var i = 0; i < 1500; i++) {
      for (final c in f.step(1 / 60)) {
        byId.putIfAbsent(c.groupId, () => []).add(c.x);
      }
    }
    expect(byId.length, greaterThan(3));
    for (final xs in byId.values) {
      expect(xs.toSet().length, 1); // same group, same x
    }
    final firstXs = byId.values.map((xs) => xs.first).toSet();
    expect(firstXs.length, byId.length); // distinct groups, distinct x
  });

  test('group ids restart after reset', () {
    final f = make();
    for (var i = 0; i < 600; i++) {
      f.step(1 / 60);
    }
    f.reset();
    final spawned = <int>[];
    for (var i = 0; i < 600; i++) {
      spawned.addAll(f.step(1 / 60).map((c) => c.groupId));
    }
    expect(spawned.first, 0);
  });
}
