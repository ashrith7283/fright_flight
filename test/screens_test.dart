import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fright_flight/game/fright_flight_game.dart';
import 'package:fright_flight/game/logic/run_controller.dart';
import 'package:fright_flight/game/logic/score_keeper.dart';
import 'package:fright_flight/services/audio_service.dart';
import 'package:fright_flight/game/logic/medals.dart';
import 'package:fright_flight/ui/main_menu.dart';
import 'package:fright_flight/core/game_config.dart';
import 'package:fright_flight/ui/medal_badge.dart';
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
          vibration: ValueNotifier(true),
          onToggleVibration: () {},
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

  group('menu stats', () {
    Widget menu({required int best, required int runs}) => _wrap(
      MainMenu(
        highScore: best,
        runsPlayed: runs,
        onPlay: () {},
        muted: ValueNotifier(false),
        onToggleMute: () {},
        vibration: ValueNotifier(true),
        onToggleVibration: () {},
      ),
    );

    testWidgets('fresh install: 0 runs and no medal', (t) async {
      await t.pumpWidget(menu(best: 0, runs: 0));
      expect(find.text('RUNS  0'), findsOneWidget);
      expect(find.byType(MedalBadge), findsNothing);
    });

    testWidgets('gold high score shows the gold medal and run count', (
      t,
    ) async {
      await t.pumpWidget(menu(best: GameConfig.goldScore, runs: 42));
      expect(find.text('RUNS  42'), findsOneWidget);
      expect(
        find.byWidgetPredicate((w) => w is MedalBadge && w.medal == Medal.gold),
        findsOneWidget,
      );
    });
  });

  testWidgets('pause button and pause menu call their callbacks', (t) async {
    var paused = 0, resumed = 0, menu = 0;
    await t.pumpWidget(_wrap(PauseButton(onPause: () => paused++)));
    await t.tap(find.byIcon(Icons.pause_rounded));
    expect(paused, 1);

    await t.pumpWidget(
      _wrap(
        PauseMenu(
          onResume: () => resumed++,
          onMenu: () => menu++,
          muted: ValueNotifier(true),
          onToggleMute: () {},
          vibration: ValueNotifier(true),
          onToggleVibration: () {},
        ),
      ),
    );
    expect(find.byIcon(Icons.volume_off), findsOneWidget);
    await t.tap(find.text('RESUME'));
    await t.tap(find.text('MENU'));
    expect((resumed, menu), (1, 1));
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
      FrightFlightGame.gameOverPanelOverlay,
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
