import 'package:flutter_test/flutter_test.dart';
import 'package:fright_flight/core/game_config.dart';
import 'package:fright_flight/game/logic/run_controller.dart';

void main() {
  late int starts, flaps, resets;
  late RunController c;

  setUp(() {
    starts = flaps = resets = 0;
    c = RunController(
      onStart: () => starts++,
      onFlap: () => flaps++,
      onReset: () => resets++,
    );
  });

  void toPlaying() {
    c.play();
    c.onTap();
  }

  test('launches in menu; play goes to ready', () {
    expect(c.state, RunState.menu);
    c.play();
    expect(c.state, RunState.ready);
  });

  test('taps ignored in menu', () {
    c.onTap();
    expect(c.state, RunState.menu);
    expect((starts, flaps), (0, 0));
  });

  test('first tap in ready starts and flaps', () {
    c.play();
    c.onTap();
    expect(c.state, RunState.playing);
    expect((starts, flaps), (1, 1));
  });

  test('taps while playing flap', () {
    toPlaying();
    c.onTap();
    expect(flaps, 2);
  });

  test('pause and resume round trip; taps ignored while paused', () {
    toPlaying();
    c.pause();
    expect(c.state, RunState.paused);
    c.onTap();
    expect(flaps, 1);
    expect(c.state, RunState.paused);
    c.resume();
    expect(c.state, RunState.playing);
  });

  test('pause only from playing', () {
    c.pause();
    expect(c.state, RunState.menu);
    c.play();
    c.pause();
    expect(c.state, RunState.ready);
    toPlaying();
    c.crash();
    c.pause();
    expect(c.state, RunState.gameOver);
  });

  test('resume only from paused', () {
    c.play();
    c.resume();
    expect(c.state, RunState.ready);
  });

  test('crash freezes: taps do not flap', () {
    toPlaying();
    c.crash();
    expect(c.state, RunState.gameOver);
    c.onTap();
    expect(flaps, 1);
  });

  test('crash ignored while paused', () {
    toPlaying();
    c.pause();
    c.crash();
    expect(c.state, RunState.paused);
  });

  test('tap ignored during delay, restarts after', () {
    toPlaying();
    c.crash();
    c.update(GameConfig.restartDelay / 2);
    c.onTap();
    expect(c.state, RunState.gameOver);
    expect(resets, 0);
    c.update(GameConfig.restartDelay);
    c.onTap();
    expect(c.state, RunState.ready);
    expect(resets, 1);
  });

  test('canRestart flips after restartDelay', () {
    toPlaying();
    expect(c.canRestart, isFalse);
    c.crash();
    expect(c.canRestart, isFalse);
    c.update(GameConfig.restartDelay / 2);
    expect(c.canRestart, isFalse);
    c.update(GameConfig.restartDelay);
    expect(c.canRestart, isTrue);
    c.restart();
    expect(c.state, RunState.ready);
    expect(c.canRestart, isFalse);
  });

  test('restart before the delay does nothing', () {
    toPlaying();
    c.crash();
    c.restart();
    expect(c.state, RunState.gameOver);
    expect(resets, 0);
  });

  test('restart timer does not advance while paused', () {
    toPlaying();
    c.pause();
    c.update(GameConfig.restartDelay * 10);
    c.resume();
    c.crash();
    expect(c.canRestart, isFalse);
  });

  test('toMenu from ready, paused and game over resets the scene', () {
    c.play();
    c.toMenu();
    expect((c.state, resets), (RunState.menu, 1));

    toPlaying();
    c.pause();
    c.toMenu();
    expect((c.state, resets), (RunState.menu, 2));

    toPlaying();
    c.crash();
    c.toMenu();
    expect((c.state, resets), (RunState.menu, 3));
  });
}
