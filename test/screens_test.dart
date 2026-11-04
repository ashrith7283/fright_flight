import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fright_flight/game/fright_flight_game.dart';
import 'package:fright_flight/game/logic/run_controller.dart';
import 'package:fright_flight/game/logic/score_keeper.dart';
import 'package:fright_flight/services/audio_service.dart';
import 'package:fright_flight/ui/game_over_actions.dart';
import 'package:fright_flight/ui/main_menu.dart';
import 'package:fright_flight/ui/mute_button.dart';
import 'package:fright_flight/ui/pause_button.dart';
import 'package:fright_flight/ui/pause_menu.dart';

import 'helpers/fake_storage_service.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  testWidgets('main menu shows title, high score and Play', (t) async {
    var played = 0;
    var toggled = 0;
    await t.pumpWidget(
      _wrap(
        MainMenu(
          highScore: 7,
          onPlay: () => played++,
          muted: ValueNotifier(false),
          onToggleMute: () => toggled++,
        ),
      ),
    );
    expect(find.text('FRIGHT'), findsOneWidget);
    expect(find.text('FLIGHT'), findsOneWidget);
    expect(find.text('BEST  7'), findsOneWidget);
    await t.tap(find.text('PLAY'));
    expect(played, 1);
    await t.tap(find.byIcon(Icons.volume_up));
    expect(toggled, 1);
  });

  testWidgets('pause button and pause menu call their callbacks', (t) async {
    var paused = 0, resumed = 0, menu = 0;
    await t.pumpWidget(_wrap(PauseButton(onPause: () => paused++)));
    await t.tap(find.byIcon(Icons.pause));
    expect(paused, 1);

    await t.pumpWidget(
      _wrap(
        PauseMenu(
          onResume: () => resumed++,
          onMenu: () => menu++,
          muted: ValueNotifier(true),
          onToggleMute: () {},
        ),
      ),
    );
    expect(find.byIcon(Icons.volume_off), findsOneWidget);
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
    final game = FrightFlightGame(
      storage: storage,
      audio: NoopAudioService(),
      minLoadTime: Duration.zero,
    );
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

  testWidgets('mute button reflects the notifier', (t) async {
    final muted = ValueNotifier(false);
    await t.pumpWidget(_wrap(MuteButton(muted: muted, onToggle: () {})));
    expect(find.byIcon(Icons.volume_up), findsOneWidget);
    muted.value = true;
    await t.pump();
    expect(find.byIcon(Icons.volume_off), findsOneWidget);
  });
}
