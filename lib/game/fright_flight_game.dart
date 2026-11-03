import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/widgets.dart' show AppLifecycleState;

import '../core/game_config.dart';
import 'components/background_component.dart';
import 'components/cloud_component.dart';
import 'components/plane_component.dart';
import 'components/score_hud.dart';
import 'components/smoke_trail.dart';
import 'logic/cloud_field.dart';
import 'logic/collision_rules.dart';
import 'logic/lane_picker.dart';
import 'logic/plane_body.dart';
import 'logic/run_controller.dart';
import 'logic/score_keeper.dart';
import '../services/storage_service.dart';

class FrightFlightGame extends FlameGame with TapCallbacks {
  FrightFlightGame({Random? random, StorageService? storage})
    : super(
        camera: CameraComponent.withFixedResolution(
          width: GameConfig.worldWidth,
          height: GameConfig.worldHeight,
        ),
      ) {
    _field = CloudField(LanePicker(random));
    _score = ScoreKeeper(storage ?? SharedPreferencesStorageService());
    _run = RunController(onStart: () {}, onFlap: _body.flap, onReset: _reset);
  }

  final PlaneBody _body = PlaneBody();
  late final CloudField _field;
  late final RunController _run;
  late final ScoreKeeper _score;
  final Map<Object, CloudComponent> _cloudComponents = {};
  late final SmokeTrail _smoke;

  RunState get runState => _run.state;
  int get highScore => _score.highScore;

  static const mainMenuOverlay = 'mainMenu';
  static const pauseButtonOverlay = 'pauseButton';
  static const pauseMenuOverlay = 'pauseMenu';
  static const gameOverActionsOverlay = 'gameOverActions';

  void play() => _transition(_run.play);
  void pause() => _transition(_run.pause);
  void resume() => _transition(_run.resume);
  void toMenu() => _transition(_run.toMenu);
  void restart() => _transition(_run.restart);

  void _transition(void Function() action) {
    action();
    _syncOverlays();
  }

  /// Maps the run state to the overlay set. Idempotent; call after every
  /// transition so overlays cannot drift from state.
  void _syncOverlays() {
    final wanted = <String>{
      if (_run.state == RunState.menu) mainMenuOverlay,
      if (_run.state == RunState.playing) pauseButtonOverlay,
      if (_run.state == RunState.paused) pauseMenuOverlay,
      if (_run.canRestart) gameOverActionsOverlay,
    };
    for (final name in const [
      mainMenuOverlay,
      pauseButtonOverlay,
      pauseMenuOverlay,
      gameOverActionsOverlay,
    ]) {
      if (wanted.contains(name)) {
        if (!overlays.isActive(name)) overlays.add(name);
      } else {
        overlays.remove(name);
      }
    }
  }

  @override
  void lifecycleStateChange(AppLifecycleState state) {
    super.lifecycleStateChange(state);
    // pause() only acts in the playing state; never resumes by itself.
    if (state != AppLifecycleState.resumed) pause();
  }

  @override
  Future<void> onLoad() async {
    await _score.load(); // never throws; falls back to 0
    camera.viewfinder.anchor = Anchor.topLeft;
    bool running() => _run.state == RunState.playing;
    world.add(BackgroundComponent(isRunning: running));
    _smoke = SmokeTrail(_body, isRunning: running);
    world.add(_smoke);
    world.add(PlaneComponent(_body, isRunning: running));
    world.add(ScoreHud(score: _score, runState: () => _run.state));
  }

  @override
  void onTapDown(TapDownEvent event) => _transition(_run.onTap);

  @override
  void update(double dt) {
    final step = min(dt, GameConfig.maxFrameDelta);
    _run.update(step);
    if (_run.state == RunState.gameOver) _syncOverlays();
    if (_run.state == RunState.playing) {
      _body.step(step);
      for (final spec in _field.step(step)) {
        final c = CloudComponent(spec);
        _cloudComponents[spec] = c;
        world.add(c);
      }
      _cloudComponents.removeWhere((spec, c) {
        final gone = !_field.clouds.contains(spec);
        if (gone) c.removeFromParent();
        return gone;
      });
      if (CollisionRules.hits(_body.y, _field.clouds)) {
        _transition(_run.crash);
        // Not awaited: the write must not delay game over (errors are caught).
        unawaited(_score.finishRun());
      } else {
        _score.onCloudsAdvanced(_field.clouds);
      }
    }
    super.update(step);
  }

  void _reset() {
    _score.reset();
    _body.reset();
    _smoke.clear();
    _field.reset();
    for (final c in _cloudComponents.values) {
      c.removeFromParent();
    }
    _cloudComponents.clear();
  }
}
