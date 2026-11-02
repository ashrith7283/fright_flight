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

  test('starts ready; first tap starts and flaps', () {
    expect(c.state, RunState.ready);
    c.onTap();
    expect(c.state, RunState.playing);
    expect((starts, flaps), (1, 1));
  });

  test('taps while playing flap', () {
    c.onTap();
    c.onTap();
    expect(flaps, 2);
  });

  test('crash freezes: taps do not flap', () {
    c.onTap();
    c.crash();
    expect(c.state, RunState.gameOver);
    c.onTap();
    expect(flaps, 1);
  });

  test('tap ignored during delay, restarts after', () {
    c.onTap();
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
}
