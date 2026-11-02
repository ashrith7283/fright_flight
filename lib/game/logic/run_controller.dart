import '../../core/game_config.dart';

enum RunState { menu, ready, playing, paused, gameOver }

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

  RunState state = RunState.menu;
  double _timeSinceCrash = 0;

  /// True in game over once the restart delay has elapsed.
  bool get canRestart =>
      state == RunState.gameOver && _timeSinceCrash >= GameConfig.restartDelay;

  void onTap() {
    switch (state) {
      case RunState.menu:
      case RunState.paused:
        return;
      case RunState.ready:
        state = RunState.playing;
        onStart();
        onFlap();
      case RunState.playing:
        onFlap();
      case RunState.gameOver:
        restart();
    }
  }

  /// Menu to ready.
  void play() {
    if (state != RunState.menu) return;
    state = RunState.ready;
  }

  void pause() {
    if (state == RunState.playing) state = RunState.paused;
  }

  void resume() {
    if (state == RunState.paused) state = RunState.playing;
  }

  /// Abandons any run and returns to the menu with a fresh scene.
  void toMenu() {
    state = RunState.menu;
    onReset();
  }

  /// Game over to ready, once the restart delay has elapsed.
  void restart() {
    if (!canRestart) return;
    state = RunState.ready;
    onReset();
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
