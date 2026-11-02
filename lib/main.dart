import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/game_config.dart';
import 'game/fright_flight_game.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    GameWidget(
      game: FrightFlightGame(),
      backgroundBuilder: (_) => const ColoredBox(color: GameConfig.skyColor),
    ),
  );
}
