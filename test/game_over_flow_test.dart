import 'dart:math';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fright_flight/core/game_config.dart';
import 'package:fright_flight/game/components/near_miss_label.dart';
import 'package:fright_flight/game/fright_flight_game.dart';
import 'package:fright_flight/game/logic/plane_body.dart';
import 'package:fright_flight/game/logic/run_controller.dart';
import 'package:fright_flight/services/audio_service.dart';
import 'package:fright_flight/services/haptics_service.dart';

import 'helpers/fake_storage_service.dart';

Future<FrightFlightGame> startGame(
  WidgetTester t, {
  bool reducedMotion = false,
  int? seed,
}) async {
  final game = FrightFlightGame(
    reducedMotion: () => reducedMotion,
    random: seed == null ? null : Random(seed),
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
  return game;
}

void main() {
  testWidgets('the plane hovers in the ready state', (t) async {
    final game = await startGame(t);
    final ys = <double>{};
    for (var i = 0; i < 40; i++) {
      await t.pump(const Duration(milliseconds: 40));
      ys.add(game.planeY);
      expect(
        (game.planeY - GameConfig.planeStartY).abs(),
        lessThanOrEqualTo(GameConfig.hoverAmplitude + 1e-9),
      );
    }
    expect(ys.length, greaterThan(5));
    expect(game.runState, RunState.ready);
  });

  testWidgets('touching the ceiling does not end the run', (t) async {
    final game = await startGame(t);
    // Keep flapping until well before the first cloud group arrives.
    for (var i = 0; i < 50; i++) {
      await t.tapAt(const Offset(300, 200));
      await t.pump(const Duration(milliseconds: 20));
    }
    expect(game.runState, RunState.playing);
    await t.pump(const Duration(seconds: 1)); // settle gesture timers
  });

  testWidgets('panel overlay at crash; restart enabled after the delay', (
    t,
  ) async {
    final game = await startGame(t);
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

  testWidgets(
    'after a mid-air crash the plane falls and rests; clouds freeze',
    (t) async {
      final game = await startGame(t);
      // Climb to the ceiling and stay there until the first clouds are on
      // screen (they are still far to the right), then crash mid-air.
      for (var i = 0; i < 90 && game.cloudXs.isEmpty; i++) {
        await t.tapAt(const Offset(300, 200));
        await t.pump(const Duration(milliseconds: 20));
      }
      expect(game.cloudXs, isNotEmpty);
      game.debugCrash();
      expect(game.runState, RunState.gameOver);
      final crashY = game.planeY;
      expect(crashY, lessThan(PlaneBody.groundY - 20)); // crashed in the air
      final clouds = game.cloudXs;

      // A tap during the fall does not flap the plane.
      await t.tapAt(const Offset(300, 200));
      var last = game.planeY;
      for (var i = 0; i < 60; i++) {
        await t.pump(const Duration(milliseconds: 20));
        expect(game.planeY, greaterThanOrEqualTo(last));
        last = game.planeY;
      }
      expect(game.planeY, PlaneBody.groundY);
      expect(game.cloudXs, clouds);
      expect(game.runState, RunState.gameOver);
      await t.pump(const Duration(seconds: 1)); // settle gesture timers
    },
  );

  for (final reduced in [false, true]) {
    testWidgets('crash effects start on crash and restart clears them '
        '(reduced motion: $reduced)', (t) async {
      final game = await startGame(t, reducedMotion: reduced);
      await t.tapAt(const Offset(300, 200));
      await t.pump(const Duration(milliseconds: 20));
      game.debugCrash();
      await t.pump(const Duration(milliseconds: 20));
      final fx = game.crashEffects;
      expect(fx.flashAlpha, greaterThan(0));
      final shaking = fx.shakeX != 0 || fx.shakeY != 0;
      expect(shaking, !reduced);
      expect(game.camera.viewfinder.position.x, closeTo(fx.shakeX, 1e-4));

      for (var i = 0; i < (GameConfig.restartDelay / 0.05).ceil() + 2; i++) {
        await t.pump(const Duration(milliseconds: 50));
      }
      // Force a live effect, then restart: both must stop at once.
      fx.start(reducedMotion: false);
      game.restart();
      expect(fx.flashAlpha, 0);
      expect(fx.shakeX == 0 && fx.shakeY == 0, isTrue);
      expect(game.camera.viewfinder.position.x, 0);
      expect(game.camera.viewfinder.position.y, 0);
      await t.pump(const Duration(seconds: 1)); // settle gesture timers
    });
  }

  testWidgets('a near miss shows a CLOSE! label that removes itself', (
    t,
  ) async {
    final game = await startGame(t);
    int labels() => game.world.children.whereType<NearMissLabel>().length;
    await t.tapAt(const Offset(300, 200));
    game.debugNearMiss();
    await t.pump(const Duration(milliseconds: 20));
    expect(labels(), 1);
    final frames = (GameConfig.nearMissLabelDuration / 0.05).ceil() + 2;
    for (var i = 0; i < frames; i++) {
      await t.pump(const Duration(milliseconds: 50));
    }
    expect(labels(), 0);
    await t.pump(const Duration(seconds: 1)); // settle gesture timers
  });

  // Effects are cosmetic: a seeded run played with the same inputs must give
  // the same score and state on every frame, whether the camera shakes or not.
  Future<List<String>> playScripted(WidgetTester t, bool reduced) async {
    final game = await startGame(t, reducedMotion: reduced, seed: 7);
    final log = <String>[];
    await t.tapAt(const Offset(300, 200));
    for (var i = 0; i < 400 && game.runState != RunState.gameOver; i++) {
      if (game.planeY > GameConfig.planeStartY + 25) {
        await t.tapAt(const Offset(300, 200));
      }
      await t.pump(const Duration(milliseconds: 20));
      log.add(
        '${game.runState.name}:${game.score}:${game.planeY.toStringAsFixed(3)}',
      );
    }
    // Let the post-crash effects run too.
    for (var i = 0; i < 20; i++) {
      await t.pump(const Duration(milliseconds: 20));
      log.add('${game.runState.name}:${game.score}');
    }
    await t.pump(const Duration(seconds: 1)); // settle gesture timers
    return log;
  }

  testWidgets('effects never change score or state transitions', (t) async {
    final withShake = await playScripted(t, false);
    final withoutShake = await playScripted(t, true);
    expect(withShake.length, greaterThan(20));
    expect(withShake, withoutShake);
  });
}
