import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fright_flight/game/fright_flight_game.dart';
import 'package:fright_flight/game/logic/run_controller.dart';
import 'package:fright_flight/game/logic/score_keeper.dart';
import 'package:fright_flight/ui/game_over_actions.dart';
import 'package:fright_flight/ui/main_menu.dart';
import 'package:fright_flight/ui/pause_button.dart';
import 'package:fright_flight/ui/pause_menu.dart';

import 'helpers/fake_storage_service.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  testWidgets('main menu shows title, high score and Play', (t) async {
    var played = 0;
    await t.pumpWidget(_wrap(MainMenu(highScore: 7, onPlay: () => played++)));
    expect(find.text('Fright Flight'), findsOneWidget);
    expect(find.text('High score: 7'), findsOneWidget);
    await t.tap(find.text('Play'));
    expect(played, 1);
  });

  testWidgets('pause button and pause menu call their callbacks', (t) async {
    var paused = 0, resumed = 0, menu = 0;
    await t.pumpWidget(_wrap(PauseButton(onPause: () => paused++)));
    await t.tap(find.byIcon(Icons.pause));
    expect(paused, 1);

    await t.pumpWidget(
      _wrap(PauseMenu(onResume: () => resumed++, onMenu: () => menu++)),
    );
    await t.tap(find.text('Resume'));
    await t.tap(find.text('Menu'));
    expect((resumed, menu), (1, 1));
  });

  testWidgets('game-over actions call their callbacks', (t) async {
    var restarted = 0, menu = 0;
    await t.pumpWidget(
      _wrap(
        GameOverActions(onRestart: () => restarted++, onMenu: () => menu++),
      ),
    );
    await t.tap(find.text('Restart'));
    await t.tap(find.text('Menu'));
    expect((restarted, menu), (1, 1));
  });

  testWidgets('game launches in menu; play, pause, resume, toMenu', (t) async {
    final storage = FakeStorageService();
    final game = FrightFlightGame(storage: storage);
    const names = [
      FrightFlightGame.mainMenuOverlay,
      FrightFlightGame.pauseButtonOverlay,
      FrightFlightGame.pauseMenuOverlay,
      FrightFlightGame.gameOverActionsOverlay,
    ];
    await t.pumpWidget(
      GameWidget<FrightFlightGame>(
        game: game,
        initialActiveOverlays: const [FrightFlightGame.mainMenuOverlay],
        overlayBuilderMap: {
          for (final n in names) n: (_, _) => const SizedBox(),
        },
      ),
    );
    expect(game.runState, RunState.menu);
    expect(game.overlays.isActive(FrightFlightGame.mainMenuOverlay), isTrue);
    game.play();
    expect(game.runState, RunState.ready);
    expect(game.overlays.activeOverlays, isEmpty);
    game.toMenu();
    expect(game.runState, RunState.menu);
    expect(game.overlays.isActive(FrightFlightGame.mainMenuOverlay), isTrue);
    expect(storage.writes, isEmpty);
  });

  test('abandoning a run (reset without finishRun) never writes', () async {
    final storage = FakeStorageService(stored: 1);
    final k = ScoreKeeper(storage);
    await k.load();
    k.score = 50;
    k.reset();
    expect(storage.writes, isEmpty);
    expect(k.highScore, 1);
    expect(k.score, 0);
  });
}
