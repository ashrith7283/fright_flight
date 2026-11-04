import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fright_flight/game/fright_flight_game.dart';
import 'package:fright_flight/game/logic/run_controller.dart';
import 'package:fright_flight/services/audio_service.dart';
import 'package:fright_flight/services/haptics_service.dart';

import 'helpers/fake_storage_service.dart';
import 'helpers/recording_haptics_service.dart';

Future<FrightFlightGame> _launch(
  WidgetTester t,
  RecordingHapticsService haptics,
  FakeStorageService storage,
) async {
  final game = FrightFlightGame(
    storage: storage,
    audio: NoopAudioService(),
    haptics: haptics,
    minLoadTime: Duration.zero,
  );
  await t.pumpWidget(
    MaterialApp(
      home: GameWidget<FrightFlightGame>(
        game: game,
        initialActiveOverlays: const [FrightFlightGame.mainMenuOverlay],
        overlayBuilderMap: {
          FrightFlightGame.mainMenuOverlay: (_, _) => const SizedBox(),
          FrightFlightGame.pauseButtonOverlay: (_, _) => const SizedBox(),
          FrightFlightGame.pauseMenuOverlay: (_, _) => const SizedBox(),
          FrightFlightGame.gameOverPanelOverlay: (_, _) => const SizedBox(),
        },
      ),
    ),
  );
  await t.pump();
  await t.pump();
  return game;
}

void main() {
  late RecordingHapticsService haptics;
  late FakeStorageService storage;

  setUp(() {
    haptics = RecordingHapticsService();
    storage = FakeStorageService();
  });

  testWidgets('no vibration for ignored taps; one per accepted flap', (
    t,
  ) async {
    final game = await _launch(t, haptics, storage);
    await t.tapAt(const Offset(300, 200)); // menu: ignored
    await t.pump();
    expect(haptics.count('flap'), 0);

    game.play();
    await t.tapAt(const Offset(300, 200));
    await t.pump();
    expect(game.runState, RunState.playing);
    expect(haptics.count('flap'), 1);

    game.pause();
    await t.tapAt(const Offset(300, 200)); // paused: ignored
    await t.pump(const Duration(seconds: 1));
    expect(haptics.count('flap'), 1);
  });

  testWidgets('one strong vibration on crash', (t) async {
    final game = await _launch(t, haptics, storage);
    game.play();
    await t.tapAt(const Offset(300, 200));
    for (var i = 0; i < 100; i++) {
      await t.pump(const Duration(milliseconds: 50));
    }
    expect(game.runState, RunState.gameOver);
    expect(haptics.count('crash'), 1);
    expect(haptics.count('score'), 0);
  });

  testWidgets('toggle applies, persists and survives storage failure', (
    t,
  ) async {
    final game = await _launch(t, haptics, storage);
    expect(game.vibration.value, isTrue); // default on
    game.toggleVibration();
    await t.pump();
    expect(game.vibration.value, isFalse);
    expect(haptics.lastEnabled, isFalse);
    expect(storage.hapticsWrites, [false]);
    expect(game.muted.value, isFalse); // independent of sound

    storage.failHapticsWrites = true;
    game.toggleVibration();
    await t.pump();
    expect(game.vibration.value, isTrue); // kept for the session
  });

  testWidgets('saved off is applied at startup; read failure defaults on', (
    t,
  ) async {
    storage.storedHaptics = false;
    final off = await _launch(t, haptics, storage);
    expect(off.vibration.value, isFalse);
    expect(haptics.lastEnabled, isFalse);

    await t.pumpWidget(const SizedBox());
    final failing = FakeStorageService()..failHapticsReads = true;
    final on = await _launch(t, RecordingHapticsService(), failing);
    expect(on.vibration.value, isTrue);
  });

  test(
    'real service sends nothing while disabled, one call when enabled',
    () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      final sent = <String>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, (call) async {
            if (call.method == 'HapticFeedback.vibrate') {
              sent.add(call.arguments as String);
            }
            return null;
          });
      final service = FlutterHapticsService();
      service.setEnabled(false);
      service.flap();
      service.crash();
      await Future<void>.delayed(Duration.zero);
      expect(sent, isEmpty);

      service.setEnabled(true);
      service.flap();
      service.score();
      service.crash();
      await Future<void>.delayed(Duration.zero);
      expect(sent, [
        'HapticFeedbackType.lightImpact',
        'HapticFeedbackType.selectionClick',
        'HapticFeedbackType.heavyImpact',
      ]);
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, null);
    },
  );
}
