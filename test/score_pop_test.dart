import 'package:flutter_test/flutter_test.dart';
import 'package:fright_flight/core/game_config.dart';
import 'package:fright_flight/game/components/score_hud.dart';
import 'package:fright_flight/game/logic/run_controller.dart';
import 'package:fright_flight/game/logic/score_keeper.dart';

import 'helpers/fake_storage_service.dart';

void main() {
  late ScoreKeeper keeper;
  late ScoreHud hud;
  var state = RunState.playing;

  setUp(() {
    keeper = ScoreKeeper(FakeStorageService());
    state = RunState.playing;
    hud = ScoreHud(score: keeper, runState: () => state);
  });

  test('no pop before any point', () {
    hud.update(0.1);
    expect(hud.popScale, 1);
  });

  test('pops to the peak at most and settles within the duration', () {
    keeper.score = 1;
    hud.update(0);
    expect(hud.popScale, closeTo(GameConfig.scorePopScale, 1e-9));
    var last = hud.popScale;
    for (var t = 0.0; t < GameConfig.scorePopDuration; t += 0.02) {
      hud.update(0.02);
      expect(hud.popScale, lessThanOrEqualTo(last));
      expect(hud.popScale, lessThanOrEqualTo(GameConfig.scorePopScale));
      last = hud.popScale;
    }
    hud.update(0.02);
    expect(hud.popScale, 1);
  });

  test('a quick second point restarts the pop from its peak', () {
    keeper.score = 1;
    hud.update(0);
    hud.update(GameConfig.scorePopDuration / 2);
    expect(hud.popScale, lessThan(GameConfig.scorePopScale));
    keeper.score = 2;
    hud.update(0.01);
    expect(hud.popScale, closeTo(GameConfig.scorePopScale, 1e-9));
  });

  test('a reset to zero does not pop', () {
    keeper.score = 5;
    hud.update(1);
    keeper.score = 0;
    state = RunState.ready;
    hud.update(0.01);
    expect(hud.popScale, 1);
  });
}
