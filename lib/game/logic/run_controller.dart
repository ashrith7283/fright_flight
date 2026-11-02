import '../../core/game_config.dart';

enum RunState { ready, playing, gameOver }

/// State transitions and tap dispatch. Callers supply the side effects.
class RunController {
  RunController({
    required this.onStart,
    required this.onFlap,
    required this.onReset,
  });

  final void Function() onStart;
  final void Function() onFlap;
  final void Function() onReset;

  RunState state = RunState.ready;
  double _timeSinceCrash = 0;

  void onTap() {
    switch (state) {
      case RunState.ready:
        state = RunState.playing;
        onStart();
        onFlap();
      case RunState.playing:
        onFlap();
      case RunState.gameOver:
        if (_timeSinceCrash >= GameConfig.restartDelay) {
          state = RunState.ready;
          onReset();
        }
    }
  }

  void crash() {
    if (state != RunState.playing) return;
    state = RunState.gameOver;
    _timeSinceCrash = 0;
  }

  void update(double dt) {
    if (state == RunState.gameOver) _timeSinceCrash += dt;
  }
}
