import 'package:flutter_test/flutter_test.dart';
import 'package:fright_flight/game/logic/back_action.dart';
import 'package:fright_flight/game/logic/run_controller.dart';

void main() {
  test('back action for every state', () {
    expect(backActionFor(RunState.playing), BackAction.pause);
    expect(backActionFor(RunState.paused), BackAction.resume);
    expect(backActionFor(RunState.ready), BackAction.toMenu);
    expect(backActionFor(RunState.gameOver), BackAction.toMenu);
    expect(backActionFor(RunState.menu), BackAction.exitApp);
  });
}
