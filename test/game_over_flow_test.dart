import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fright_flight/core/game_config.dart';
import 'package:fright_flight/game/fright_flight_game.dart';
import 'package:fright_flight/game/logic/run_controller.dart';
import 'package:fright_flight/services/audio_service.dart';
import 'package:fright_flight/services/haptics_service.dart';

import 'helpers/fake_storage_service.dart';

void main() {
  testWidgets('panel overlay at crash; restart enabled after the delay', (
    t,
  ) async {
    final game = FrightFlightGame(
      storage: FakeStorageService(),
      audio: NoopAudioService(),
      haptics: NoopHapticsService(),
      minLoadTime: Duration.zero,
    );
    await t.pumpWidget(
      MaterialApp(
        home: GameWidget<FrightFlightGame>(
          game: game,
          initialActiveOverlays: const [FrightFlightGame.mainMenuOverlay],
          overlayBuilderMap: {
            for (final n in [
              FrightFlightGame.mainMenuOverlay,
              FrightFlightGame.pauseButtonOverlay,
              FrightFlightGame.pauseMenuOverlay,
              FrightFlightGame.gameOverPanelOverlay,
            ])
              n: (_, _) => const SizedBox(),
          },
        ),
      ),
    );
    await t.pump();
    await t.pump();
    game.play();
    await t.tapAt(const Offset(300, 200));
    // Fall until the crash.
    while (game.runState != RunState.gameOver) {
      await t.pump(const Duration(milliseconds: 20));
    }
    expect(
      game.overlays.isActive(FrightFlightGame.gameOverPanelOverlay),
      isTrue,
    );
    expect(game.restartReady.value, isFalse);

    // Frame steps are capped, so advance in several frames.
    for (var i = 0; i < (GameConfig.restartDelay / 0.05).ceil() + 2; i++) {
      await t.pump(const Duration(milliseconds: 50));
    }
    expect(game.restartReady.value, isTrue);

    game.restart();
    expect(game.runState, RunState.ready);
    expect(
      game.overlays.isActive(FrightFlightGame.gameOverPanelOverlay),
      isFalse,
    );
    await t.pump(const Duration(seconds: 1)); // settle gesture timers
  });
}
