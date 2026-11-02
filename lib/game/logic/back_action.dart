import 'run_controller.dart';

enum BackAction { pause, resume, toMenu, exitApp }

/// What the Android back button does in each state.
BackAction backActionFor(RunState state) => switch (state) {
  RunState.playing => BackAction.pause,
  RunState.paused => BackAction.resume,
  RunState.ready || RunState.gameOver => BackAction.toMenu,
  RunState.menu => BackAction.exitApp,
};
