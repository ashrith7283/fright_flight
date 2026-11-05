import 'package:flutter_test/flutter_test.dart';
import 'package:fright_flight/core/game_config.dart';
import 'package:fright_flight/game/logic/cloud_spec.dart';
import 'package:fright_flight/game/logic/score_keeper.dart';

import 'helpers/fake_storage_service.dart';

/// Cloud whose right edge is [right].
CloudSpec cloud(int group, double right, {int lane = 1}) =>
    CloudSpec(x: right - GameConfig.cloudWidth, lane: lane, groupId: group);

const edge = GameConfig.planeStartX;

void main() {
  late FakeStorageService storage;
  late ScoreKeeper keeper;

  setUp(() {
    storage = FakeStorageService();
    keeper = ScoreKeeper(storage);
  });

  group('pass detection', () {
    test('scores when the right edge is left of the plane edge', () {
      expect(keeper.onCloudsAdvanced([cloud(0, edge - 0.1)]), 1);
      expect(keeper.score, 1);
    });

    test('equality is not yet passed', () {
      keeper.onCloudsAdvanced([cloud(0, edge)]);
      expect(keeper.score, 0);
    });

    test('two-cloud group counts once', () {
      keeper.onCloudsAdvanced([
        cloud(0, edge - 5, lane: 0),
        cloud(0, edge - 5, lane: 2),
      ]);
      expect(keeper.score, 1);
    });

    test('a group is counted only once', () {
      for (var i = 0; i < 5; i++) {
        keeper.onCloudsAdvanced([cloud(0, edge - 5 - i)]);
      }
      expect(keeper.score, 1);
    });

    test('a large step passing several groups scores each', () {
      keeper.onCloudsAdvanced([cloud(0, edge - 900), cloud(1, edge - 440)]);
      expect(keeper.score, 2);
    });

    test('score starts at 0 and reset clears it', () {
      expect(keeper.score, 0);
      keeper.onCloudsAdvanced([cloud(0, edge - 1)]);
      keeper.reset();
      expect(keeper.score, 0);
      keeper.onCloudsAdvanced([cloud(0, edge - 1)]); // ids restart per run
      expect(keeper.score, 1);
    });

    test('no score after the run has finished', () async {
      await keeper.finishRun();
      keeper.onCloudsAdvanced([cloud(0, edge - 1)]);
      expect(keeper.score, 0);
    });
  });

  group('load', () {
    test('fresh install gives 0', () async {
      await keeper.load();
      expect(keeper.highScore, 0);
    });

    test('valid stored value', () async {
      storage.stored = 7;
      await keeper.load();
      expect(keeper.highScore, 7);
    });

    test('negative stored value gives 0', () async {
      storage.stored = -3;
      await keeper.load();
      expect(keeper.highScore, 0);
    });

    test('failing read gives 0 and does not throw', () async {
      storage.stored = 9;
      storage.failReads = true;
      await keeper.load();
      expect(keeper.highScore, 0);
    });
  });

  group('finishRun', () {
    void score(int n) {
      for (var i = 0; i < n; i++) {
        keeper.onCloudsAdvanced([cloud(i, edge - 1)]);
      }
    }

    test('new best is saved once', () async {
      storage.stored = 2;
      await keeper.load();
      score(3);
      expect(storage.writes, isEmpty); // nothing during play
      await keeper.finishRun();
      await keeper.finishRun();
      expect(keeper.highScore, 3);
      expect(keeper.newBest, isTrue);
      expect(storage.writes, [3]);
    });

    test('tie changes nothing', () async {
      storage.stored = 3;
      await keeper.load();
      score(3);
      await keeper.finishRun();
      expect(keeper.highScore, 3);
      expect(keeper.newBest, isFalse);
      expect(storage.writes, isEmpty);
    });

    test('lower score changes nothing', () async {
      storage.stored = 5;
      await keeper.load();
      score(2);
      await keeper.finishRun();
      expect(keeper.highScore, 5);
      expect(storage.writes, isEmpty);
    });

    test('first run on a fresh install with score 1+', () async {
      await keeper.load();
      score(1);
      await keeper.finishRun();
      expect(keeper.highScore, 1);
      expect(keeper.newBest, isTrue);
      expect(storage.writes, [1]);
    });

    test('crash on the first group (score 0) on a fresh install', () async {
      await keeper.load();
      await keeper.finishRun();
      expect(keeper.score, 0);
      expect(keeper.highScore, 0);
      expect(keeper.newBest, isFalse);
      expect(storage.writes, isEmpty);
    });

    test('write failure keeps the in-memory value and retries later', () async {
      await keeper.load();
      storage.failWrites = true;
      score(2);
      await keeper.finishRun();
      expect(keeper.highScore, 2);
      expect(keeper.newBest, isTrue);

      storage.failWrites = false;
      keeper.reset();
      expect(keeper.highScore, 2);
      score(4);
      await keeper.finishRun();
      expect(storage.writes, [4]);
    });

    test('reset clears newBest', () async {
      await keeper.load();
      score(1);
      await keeper.finishRun();
      keeper.reset();
      expect(keeper.newBest, isFalse);
    });
  });

  group('runs played', () {
    test('loads 0 when missing, negative or unreadable', () async {
      await keeper.load();
      expect(keeper.runsPlayed, 0);
      storage.storedRuns = -4;
      await keeper.load();
      expect(keeper.runsPlayed, 0);
      storage
        ..storedRuns = 9
        ..failRunsReads = true;
      await keeper.load();
      expect(keeper.runsPlayed, 0);
    });

    test('loads a stored count independently of the high score', () async {
      storage
        ..storedRuns = 9
        ..failReads = true; // high score read fails
      await keeper.load();
      expect(keeper.runsPlayed, 9);
      expect(keeper.highScore, 0);
    });

    test('each finished run counts once and is saved once', () async {
      storage.storedRuns = 4;
      await keeper.load();
      await keeper.finishRun();
      await keeper.finishRun(); // same run again: ignored
      expect(keeper.runsPlayed, 5);
      expect(storage.runsWrites, [5]);
      keeper.reset();
      await keeper.finishRun(); // a score of 0 still counts
      expect(keeper.runsPlayed, 6);
      expect(storage.runsWrites, [5, 6]);
    });

    test('an abandoned run is not counted', () async {
      await keeper.load();
      keeper.onCloudsAdvanced([cloud(0, edge - 1)]);
      keeper.reset(); // what returning to the menu from pause does
      expect(keeper.runsPlayed, 0);
      expect(storage.runsWrites, isEmpty);
    });

    test(
      'a failed write keeps the in-memory count and the high score save',
      () async {
        await keeper.load();
        storage.failRunsWrites = true;
        keeper.onCloudsAdvanced([cloud(0, edge - 1)]);
        await keeper.finishRun();
        expect(keeper.runsPlayed, 1);
        expect(storage.writes, [1]); // high score still saved
        storage.failRunsWrites = false;
        keeper.reset();
        await keeper.finishRun();
        expect(storage.runsWrites, [2]);
      },
    );

    test('newBest is set before any write completes', () async {
      await keeper.load();
      keeper.onCloudsAdvanced([cloud(0, edge - 1)]);
      final done = keeper.finishRun(); // not awaited, as in the game
      expect(keeper.newBest, isTrue);
      expect(keeper.runsPlayed, 1);
      await done;
    });
  });
}
