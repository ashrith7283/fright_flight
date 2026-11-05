import 'package:flutter_test/flutter_test.dart';
import 'package:fright_flight/core/game_config.dart';
import 'package:fright_flight/game/components/ready_prompt.dart';
import 'package:fright_flight/game/logic/run_controller.dart';

void main() {
  test('visible only in the ready state', () {
    for (final s in RunState.values) {
      final p = ReadyPrompt(runState: () => s);
      expect(p.isVisible, s == RunState.ready, reason: '$s');
    }
  });

  test('pulses between the minimum alpha and full brightness', () {
    final p = ReadyPrompt(runState: () => RunState.ready);
    expect(p.alpha, closeTo(1, 1e-9));
    final seen = <double>[];
    for (var i = 0; i < 120; i++) {
      p.update(1 / 60);
      seen.add(p.alpha);
      expect(p.alpha, inInclusiveRange(GameConfig.promptMinAlpha - 1e-9, 1));
    }
    expect(seen.reduce((a, b) => a < b ? a : b), lessThan(0.5));
  });

  test('pulse restarts when ready is entered again', () {
    var state = RunState.ready;
    final p = ReadyPrompt(runState: () => state);
    p.update(0.3);
    state = RunState.playing;
    p.update(0.1);
    state = RunState.ready;
    expect(p.alpha, closeTo(1, 1e-9));
  });
}
