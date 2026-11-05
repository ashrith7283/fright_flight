import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:fright_flight/core/game_config.dart';
import 'package:fright_flight/game/logic/cloud_field.dart';
import 'package:fright_flight/game/logic/cloud_spec.dart';
import 'package:fright_flight/game/logic/difficulty_curve.dart';
import 'package:fright_flight/game/logic/lane_picker.dart';

CloudField make() => CloudField(LanePicker(Random(3)));

void main() {
  groupIdTests();
  rampTests();
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

/// Steps [f] at [score] until [groups] new groups have spawned and returns
/// the left x of each new group, in spawn order, at the moment of return.
List<CloudSpec> spawnGroups(CloudField f, int score, int groups) {
  final out = <CloudSpec>[];
  final ids = <int>{};
  while (ids.length < groups) {
    for (final c in f.step(1 / 60, score: score)) {
      if (ids.add(c.groupId)) out.add(c);
    }
  }
  return out;
}

void rampTests() {
  group('spacing ramp', () {
    test('steady spacing at a fixed score', () {
      final f = make();
      final g = spawnGroups(f, 30, 3);
      expect(g[1].x - g[0].x, closeTo(DifficultyCurve.spacingFor(30), 1e-6));
      expect(g[2].x - g[1].x, closeTo(DifficultyCurve.spacingFor(30), 1e-6));
    });

    test('spacing shrinks once the score rises', () {
      final f = make();
      final early = spawnGroups(f, 0, 2);
      final late = spawnGroups(f, GameConfig.rampEndScore, 1).single;
      expect(early[1].x - early[0].x, closeTo(GameConfig.spawnSpacing, 1e-6));
      expect(late.x - early[1].x, closeTo(GameConfig.minSpawnSpacing, 1e-6));
    });

    test('spacing never goes below the floor', () {
      final f = make();
      final g = spawnGroups(f, 10000, 3);
      expect(g[2].x - g[1].x, closeTo(GameConfig.minSpawnSpacing, 1e-6));
    });
  });

  group('moving clouds', () {
    List<List<CloudSpec>> groupsAt(int score, int n) {
      final f = CloudField(LanePicker(Random(11)));
      final byGroup = <int, List<CloudSpec>>{};
      while (byGroup.length < n) {
        for (final c in f.step(1 / 30, score: score)) {
          byGroup.putIfAbsent(c.groupId, () => []).add(c);
        }
      }
      return byGroup.values.toList();
    }

    test('none below the moving-cloud score', () {
      final groups = groupsAt(GameConfig.movingCloudScore - 1, 400);
      expect(groups.expand((g) => g).any((c) => c.moving), isFalse);
    });

    test('only single clouds move, at about the configured chance', () {
      final groups = groupsAt(GameConfig.movingCloudScore, 1500);
      final singles = groups.where((g) => g.length == 1).toList();
      expect(
        groups
            .where((g) => g.length == 2)
            .expand((g) => g)
            .any((c) => c.moving),
        isFalse,
      );
      final share =
          singles.where((g) => g.single.moving).length / singles.length;
      expect(share, closeTo(GameConfig.movingCloudChance, 0.08));
    });

    test('a moving cloud stays within its amplitude and its lane', () {
      final c = CloudSpec(x: 400, lane: 2, groupId: 0, moving: true, phase: 1);
      for (var i = 0; i < 300; i++) {
        c.age = i / 60;
        final off = (c.centreY - c.laneCentreY).abs();
        expect(off, lessThanOrEqualTo(GameConfig.movingCloudAmplitude + 1e-9));
        expect(c.bounds.top, greaterThanOrEqualTo(2 * GameConfig.laneHeight));
        expect(c.bounds.bottom, lessThanOrEqualTo(3 * GameConfig.laneHeight));
      }
    });

    test('it drifts only while the field is stepped', () {
      final f = CloudField(LanePicker(Random(11)));
      CloudSpec? mover;
      while (mover == null) {
        f.step(1 / 30, score: GameConfig.movingCloudScore);
        mover = f.clouds.where((c) => c.moving).firstOrNull;
      }
      final y0 = mover.centreY;
      // Not stepping is what pause and game over do.
      expect(mover.centreY, y0);
      f.step(0.3, score: GameConfig.movingCloudScore);
      expect(mover.centreY, isNot(y0));
    });
  });
}
