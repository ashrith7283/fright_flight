import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart' show ValueNotifier, visibleForTesting;
import 'package:flutter/widgets.dart' show AppLifecycleState, MediaQuery;

import '../core/game_config.dart';
import 'components/background_component.dart';
import 'components/cloud_component.dart';
import 'components/crash_flash.dart';
import 'components/near_miss_label.dart';
import 'components/plane_component.dart';
import 'components/ready_prompt.dart';
import 'components/score_hud.dart';
import 'components/smoke_trail.dart';
import 'logic/cloud_field.dart';
import 'logic/collision_rules.dart';
import 'logic/difficulty_curve.dart';
import 'logic/lane_picker.dart';
import 'logic/crash_effects.dart';
import 'logic/near_miss_tracker.dart';
import 'logic/plane_body.dart';
import 'logic/run_controller.dart';
import 'logic/score_keeper.dart';
import '../services/audio_service.dart';
import '../services/haptics_service.dart';
import '../services/storage_service.dart';

class FrightFlightGame extends FlameGame with TapCallbacks {
  FrightFlightGame({
    Random? random,
    StorageService? storage,
    AudioService? audio,
    HapticsService? haptics,
    Duration? minLoadTime,
    bool Function()? reducedMotion,
  }) : super(
         camera: CameraComponent.withFixedResolution(
           width: GameConfig.worldWidth,
           height: GameConfig.worldHeight,
         ),
       ) {
    _field = CloudField(LanePicker(random));
    _storage = storage ?? SharedPreferencesStorageService();
    _score = ScoreKeeper(_storage);
    _audio = audio ?? FlameAudioService();
    _haptics = haptics ?? FlutterHapticsService();
    _minLoadTime = minLoadTime ?? GameConfig.loadingMinDuration;
    _reducedMotion = reducedMotion ?? _systemReducedMotion;
    _run = RunController(
      onStart: () {},
      onFlap: () {
        _body.flap();
        _audio.playFlap();
        _haptics.flap();
      },
      onReset: _reset,
    );
  }

  final PlaneBody _body = PlaneBody();
  final CrashEffects _crashFx = CrashEffects();
  final Vector2 _shake = Vector2.zero(); // reused camera offset
  final NearMissTracker _nearMiss = NearMissTracker();

  /// Shows a "CLOSE!" label above the plane.
  void _showNearMiss() => world.add(
    NearMissLabel(
      at: Vector2(
        GameConfig.planeStartX + GameConfig.planeWidth / 2,
        _body.y - 8,
      ),
      isPaused: () => _run.state == RunState.paused,
    ),
  );

  /// Triggers the near-miss feedback, for tests.
  @visibleForTesting
  void debugNearMiss() => _showNearMiss();
  late final bool Function() _reducedMotion;

  /// The device's "remove animations" / reduced-motion setting.
  bool _systemReducedMotion() {
    final ctx = buildContext;
    return ctx != null && (MediaQuery.maybeDisableAnimationsOf(ctx) ?? false);
  }

  /// Current crash effects, for tests.
  @visibleForTesting
  CrashEffects get crashEffects => _crashFx;
  double _hoverTime = 0; // seconds spent in the ready state since the reset

  /// Plane height, for tests.
  @visibleForTesting
  double get planeY => _body.y;

  /// Ends the run as a collision would, for tests that need a crash at a
  /// known moment.
  @visibleForTesting
  void debugCrash() => _transition(_run.crash);

  /// Cloud positions, for tests.
  @visibleForTesting
  List<double> get cloudXs => [for (final c in _field.clouds) c.x];
  late final CloudField _field;
  late final RunController _run;
  late final ScoreKeeper _score;
  late final StorageService _storage;
  late final AudioService _audio;
  late final HapticsService _haptics;
  late final Duration _minLoadTime;

  /// Mute setting, shared by the menu buttons.
  final ValueNotifier<bool> muted = ValueNotifier(false);

  /// Vibration setting (on by default), shared by the menu buttons.
  final ValueNotifier<bool> vibration = ValueNotifier(true);
  final Map<Object, CloudComponent> _cloudComponents = {};
  late final SmokeTrail _smoke;

  RunState get runState => _run.state;
  int get highScore => _score.highScore;
  int get score => _score.score;
  int get runsPlayed => _score.runsPlayed;
  bool get newBest => _score.newBest;

  /// True once the restart delay has passed in the game-over state.
  final ValueNotifier<bool> restartReady = ValueNotifier(false);

  static const mainMenuOverlay = 'mainMenu';
  static const pauseButtonOverlay = 'pauseButton';
  static const pauseMenuOverlay = 'pauseMenu';
  static const gameOverPanelOverlay = 'gameOverPanel';

  void play() => _transition(_run.play);
  void pause() => _transition(_run.pause);
  void resume() => _transition(_run.resume);
  void toMenu() => _transition(_run.toMenu);
  void restart() => _transition(_run.restart);

  void _transition(void Function() action) {
    final before = _run.state;
    action();
    if (before == RunState.playing && _run.state == RunState.gameOver) {
      _crashFx.start(reducedMotion: _reducedMotion());
    }
    _syncOverlays();
    _syncMusic(before, _run.state);
  }

  /// Maps a run-state change to a music action.
  void _syncMusic(RunState before, RunState after) {
    if (before == after) return;
    switch (after) {
      case RunState.ready:
        _audio.startMusic(); // from the menu or after game over
      case RunState.playing:
        if (before == RunState.paused) _audio.resumeMusic();
      case RunState.paused:
        _audio.pauseMusic();
      case RunState.menu:
      case RunState.gameOver:
        _audio.stopMusic();
    }
  }

  void toggleMute() {
    muted.value = !muted.value;
    _audio.setMuted(muted.value);
    _storage.writeMuted(muted.value).catchError((_) {
      // The in-memory setting stays for this session.
    });
  }

  void toggleVibration() {
    vibration.value = !vibration.value;
    _haptics.setEnabled(vibration.value);
    _storage.writeHaptics(vibration.value).catchError((_) {
      // The in-memory setting stays for this session.
    });
  }

  /// Maps the run state to the overlay set. Idempotent; call after every
  /// transition so overlays cannot drift from state.
  void _syncOverlays() {
    final wanted = <String>{
      if (_run.state == RunState.menu) mainMenuOverlay,
      if (_run.state == RunState.playing) pauseButtonOverlay,
      if (_run.state == RunState.paused) pauseMenuOverlay,
      if (_run.state == RunState.gameOver) gameOverPanelOverlay,
    };
    for (final name in const [
      mainMenuOverlay,
      pauseButtonOverlay,
      pauseMenuOverlay,
      gameOverPanelOverlay,
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
    if (state != AppLifecycleState.resumed) {
      pause();
      _audio.pauseMusic(); // also covers the ready state
    } else if (_run.state == RunState.ready) {
      _audio.resumeMusic();
    }
  }

  @override
  Future<void> onLoad() async {
    // The loading screen stays up until both the real loading and the
    // minimum display time are done.
    final minTime = _minLoadTime == Duration.zero
        ? Future<void>.value()
        : Future<void>.delayed(_minLoadTime);
    try {
      await _score.load(); // never throws; falls back to 0
      try {
        muted.value = await _storage.readMuted() ?? false;
      } catch (_) {
        muted.value = false;
      }
      try {
        vibration.value = await _storage.readHaptics() ?? true;
      } catch (_) {
        vibration.value = true;
      }
      _haptics.setEnabled(vibration.value);
      _audio.setMuted(muted.value);
      await _audio.preload(); // never throws
    } catch (_) {
      // Last-resort guard: loading must never keep the app on the loader.
    }
    camera.viewfinder.anchor = Anchor.topLeft;
    bool running() => _run.state == RunState.playing;
    world.add(
      BackgroundComponent(isRunning: running, score: () => _score.score),
    );
    _smoke = SmokeTrail(
      _body,
      isRunning: running,
      speed: () => DifficultyCurve.speedFor(_score.score),
    );
    world.add(_smoke);
    world.add(PlaneComponent(_body, isRunning: running));
    world.add(ScoreHud(score: _score, runState: () => _run.state));
    world.add(ReadyPrompt(runState: () => _run.state));
    world.add(CrashFlash(_crashFx));
    await minTime;
  }

  @override
  void onTapDown(TapDownEvent event) => _transition(_run.onTap);

  @override
  void update(double dt) {
    final step = min(dt, GameConfig.maxFrameDelta);
    _run.update(step);
    _crashFx.update(step);
    // The getter returns a copy, so assign through the setter.
    camera.viewfinder.position = _shake
      ..setValues(_crashFx.shakeX, _crashFx.shakeY);
    restartReady.value = _run.canRestart;
    if (_run.state == RunState.ready) {
      _hoverTime += step;
      _body.hover(_hoverTime);
    }
    if (_run.state == RunState.gameOver) {
      _body.fallToGround(step); // clouds stay frozen; taps never flap here
    }
    if (_run.state == RunState.playing) {
      _body.step(step);
      final speed = DifficultyCurve.speedFor(_score.score);
      for (final spec in _field.step(step, speed: speed, score: _score.score)) {
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
        _transition(_run.crash); // stops the music
        _audio.playCrash();
        _haptics.crash();
        // Not awaited: the write must not delay game over (errors are caught).
        unawaited(_score.finishRun());
      } else {
        if (_score.onCloudsAdvanced(_field.clouds) > 0) {
          _audio.playScore();
          _haptics.score();
        }
        for (var i = _nearMiss.update(_body.y, _field.clouds); i > 0; i--) {
          _showNearMiss();
        }
      }
    }
    super.update(step);
  }

  void _reset() {
    _score.reset();
    _body.reset();
    _hoverTime = 0;
    _crashFx.clear();
    _nearMiss.reset();
    for (final l in world.children.whereType<NearMissLabel>().toList()) {
      l.removeFromParent();
    }
    camera.viewfinder.position = _shake..setZero();
    _smoke.clear();
    _field.reset();
    for (final c in _cloudComponents.values) {
      c.removeFromParent();
    }
    _cloudComponents.clear();
  }
}
