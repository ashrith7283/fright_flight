import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/game_config.dart';
import 'game/fright_flight_game.dart';
import 'game/logic/back_action.dart';
import 'ui/game_over_actions.dart';
import 'ui/main_menu.dart';
import 'ui/pause_button.dart';
import 'ui/pause_menu.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(const FrightFlightApp());
}

class FrightFlightApp extends StatefulWidget {
  const FrightFlightApp({super.key});

  @override
  State<FrightFlightApp> createState() => _FrightFlightAppState();
}

class _FrightFlightAppState extends State<FrightFlightApp> {
  final FrightFlightGame _game = FrightFlightGame();

  void _onBack() {
    switch (backActionFor(_game.runState)) {
      case BackAction.pause:
        _game.pause();
      case BackAction.resume:
        _game.resume();
      case BackAction.toMenu:
        _game.toMenu();
      case BackAction.exitApp:
        SystemNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) _onBack();
        },
        child: GameWidget<FrightFlightGame>(
          game: _game,
          backgroundBuilder: (_) =>
              const ColoredBox(color: GameConfig.skyColor),
          initialActiveOverlays: const [FrightFlightGame.mainMenuOverlay],
          overlayBuilderMap: {
            FrightFlightGame.mainMenuOverlay: (_, g) =>
                MainMenu(highScore: g.highScore, onPlay: g.play),
            FrightFlightGame.pauseButtonOverlay: (_, g) =>
                PauseButton(onPause: g.pause),
            FrightFlightGame.pauseMenuOverlay: (_, g) =>
                PauseMenu(onResume: g.resume, onMenu: g.toMenu),
            FrightFlightGame.gameOverActionsOverlay: (_, g) =>
                GameOverActions(onRestart: g.restart, onMenu: g.toMenu),
          },
        ),
      ),
    );
  }
}
