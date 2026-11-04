import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fright_flight/game/fright_flight_game.dart';
import 'package:fright_flight/game/logic/run_controller.dart';

import 'helpers/fake_storage_service.dart';
import 'helpers/recording_audio_service.dart';

Future<FrightFlightGame> _launch(
  WidgetTester t,
  RecordingAudioService audio,
  FakeStorageService storage,
) async {
  final game = FrightFlightGame(
    storage: storage,
    audio: audio,
    minLoadTime: Duration.zero,
  );
  const names = [
    FrightFlightGame.mainMenuOverlay,
    FrightFlightGame.pauseButtonOverlay,
    FrightFlightGame.pauseMenuOverlay,
    FrightFlightGame.gameOverPanelOverlay,
  ];
  await t.pumpWidget(
    MaterialApp(
      home: GameWidget<FrightFlightGame>(
        game: game,
        initialActiveOverlays: const [FrightFlightGame.mainMenuOverlay],
        overlayBuilderMap: {
          for (final n in names) n: (_, _) => const SizedBox(),
        },
      ),
    ),
  );
  await t.pump();
  await t.pump();
  return game;
}

void main() {
  late RecordingAudioService audio;
  late FakeStorageService storage;

  setUp(() {
    audio = RecordingAudioService();
    storage = FakeStorageService();
  });

  testWidgets('music follows the run state', (t) async {
    final game = await _launch(t, audio, storage);
    game.play();
    expect(audio.count('startMusic'), 1);
    game.pause(); // ignored in ready
    expect(audio.count('pauseMusic'), 0);
    game.toMenu();
    expect(audio.count('stopMusic'), 1);
  });

  testWidgets('tap flaps once, pause and resume drive the music', (t) async {
    final game = await _launch(t, audio, storage);
    game.play();
    await t.tapAt(const Offset(300, 200));
    await t.pump();
    expect(game.runState, RunState.playing);
    expect(audio.count('flap'), 1);

    game.pause();
    expect(audio.count('pauseMusic'), 1);
    await t.tapAt(const Offset(300, 200)); // ignored while paused
    await t.pump();
    expect(audio.count('flap'), 1);

    game.resume();
    expect(audio.count('resumeMusic'), 1);
    await t.pump(const Duration(seconds: 1)); // settle gesture timers
  });

  testWidgets('no flap in the menu; crash stops music and sounds once', (
    t,
  ) async {
    final game = await _launch(t, audio, storage);
    await t.tapAt(const Offset(300, 200)); // menu: ignored
    await t.pump();
    expect(audio.count('flap'), 0);

    game.play();
    await t.tapAt(const Offset(300, 200));
    // Let the plane fall into the ground.
    for (var i = 0; i < 100; i++) {
      await t.pump(const Duration(milliseconds: 50));
    }
    expect(game.runState, RunState.gameOver);
    expect(audio.count('crash'), 1);
    expect(audio.count('stopMusic'), 1);
    expect(audio.count('score'), 0);
  });

  testWidgets('mute toggles, applies to audio and persists', (t) async {
    final game = await _launch(t, audio, storage);
    expect(game.muted.value, isFalse);
    game.toggleMute();
    await t.pump();
    expect(game.muted.value, isTrue);
    expect(audio.lastMuted, isTrue);
    expect(storage.mutedWrites, [true]);
  });

  testWidgets('saved mute is applied at startup', (t) async {
    storage.storedMuted = true;
    final game = await _launch(t, audio, storage);
    expect(game.muted.value, isTrue);
    expect(audio.lastMuted, isTrue);
  });

  testWidgets('storage failures never break mute', (t) async {
    storage.failMutedReads = true;
    final game = await _launch(t, audio, storage);
    expect(game.muted.value, isFalse);
    storage.failMutedWrites = true;
    game.toggleMute();
    await t.pump();
    expect(game.muted.value, isTrue); // kept for the session
  });
}
