import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fright_flight/game/fright_flight_game.dart';
import 'package:fright_flight/services/audio_service.dart';
import 'package:fright_flight/ui/loading_screen.dart';

import 'helpers/fake_storage_service.dart';

Widget _app(FrightFlightGame game) => MaterialApp(
  home: GameWidget<FrightFlightGame>(
    game: game,
    loadingBuilder: (_) => const LoadingScreen(),
    initialActiveOverlays: const [FrightFlightGame.mainMenuOverlay],
    overlayBuilderMap: {
      FrightFlightGame.mainMenuOverlay: (_, _) => const Text('MENU'),
    },
  ),
);

void main() {
  testWidgets('loading screen shows, is held for the minimum time, then menu', (
    t,
  ) async {
    final game = FrightFlightGame(
      storage: FakeStorageService(),
      audio: NoopAudioService(),
      minLoadTime: const Duration(milliseconds: 500),
    );
    await t.pumpWidget(_app(game));
    expect(find.byType(LoadingScreen), findsOneWidget);
    expect(find.text('Loading...'), findsOneWidget);
    expect(find.text('MENU'), findsNothing);

    await t.pump(const Duration(milliseconds: 300)); // before the minimum
    expect(find.byType(LoadingScreen), findsOneWidget);

    await t.pump(const Duration(milliseconds: 300));
    await t.pump();
    await t.pump();
    expect(find.byType(LoadingScreen), findsNothing);
    expect(find.text('MENU'), findsOneWidget);
  });

  testWidgets('failing storage still ends loading with defaults', (t) async {
    final storage = FakeStorageService()
      ..failReads = true
      ..failMutedReads = true;
    final game = FrightFlightGame(
      storage: storage,
      audio: NoopAudioService(),
      minLoadTime: Duration.zero,
    );
    await t.pumpWidget(_app(game));
    await t.pump();
    await t.pump();
    expect(find.byType(LoadingScreen), findsNothing);
    expect(find.text('MENU'), findsOneWidget);
    expect(game.highScore, 0);
    expect(game.muted.value, isFalse);
  });
}
