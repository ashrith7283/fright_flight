import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';

/// Sound effects and music. Implementations must never throw: audio problems
/// must not reach gameplay.
abstract class AudioService {
  Future<void> preload();
  void playFlap();
  void playScore();
  void playCrash();

  /// Starts the music from the beginning.
  void startMusic();

  /// Pauses the music if it is playing.
  void pauseMusic();

  /// Resumes the music if it was paused.
  void resumeMusic();
  void stopMusic();

  /// While muted nothing is audible; music state is kept so unmuting resumes.
  void setMuted(bool muted);
}

enum _Music { stopped, playing, paused }

/// Real audio. Built to stay fast over many runs: effects use reusable
/// [AudioPool]s and the music uses one persistent player (the source is loaded
/// once; stop/start only seek), instead of creating a player per sound. Music
/// commands are serialised so they cannot race or pile up.
class FlameAudioService implements AudioService {
  static const _flap = 'flap.wav';
  static const _score = 'score.wav';
  static const _crash = 'crash.wav';
  static const _music = 'music.m4a';
  static const _musicVolume = 0.5;

  static final _context = AudioContextConfig(
    focus: AudioContextConfigFocus.mixWithOthers,
  ).build();

  AudioPool? _flapPool;
  AudioPool? _scorePool;
  AudioPool? _crashPool;
  final AudioPlayer _player = AudioPlayer();

  bool _muted = false;
  _Music _wanted = _Music.stopped; // what the game wants
  bool _restartPending = false; // next audible start begins at 0
  bool _loaded = false; // source set on the player
  bool _playing = false; // what the player is actually doing
  Future<void> _queue = Future.value();

  Future<void> _safe(Future<void> Function() action) async {
    try {
      await action();
    } catch (e) {
      debugPrint('Audio error: $e');
    }
  }

  @override
  Future<void> preload() async {
    await _safe(() async {
      _flapPool = await FlameAudio.createPool(
        _flap,
        minPlayers: 2,
        maxPlayers: 4,
        audioContext: _context,
      );
      _scorePool = await FlameAudio.createPool(
        _score,
        minPlayers: 1,
        maxPlayers: 2,
        audioContext: _context,
      );
      _crashPool = await FlameAudio.createPool(
        _crash,
        minPlayers: 1,
        maxPlayers: 2,
        audioContext: _context,
      );
    });
    _enqueue(_loadMusic);
  }

  Future<void> _loadMusic() async {
    if (_loaded) return;
    _player.audioCache = FlameAudio.audioCache;
    await _player.setAudioContext(_context);
    await _player.setReleaseMode(ReleaseMode.loop);
    await _player.setVolume(_musicVolume);
    await _player.setSource(AssetSource(_music));
    _loaded = true;
  }

  void _effect(AudioPool? pool) {
    if (_muted || pool == null) return;
    _safe(pool.start);
  }

  @override
  void playFlap() => _effect(_flapPool);
  @override
  void playScore() => _effect(_scorePool);
  @override
  void playCrash() => _effect(_crashPool);

  void _enqueue(Future<void> Function() op) {
    _queue = _queue.then((_) => _safe(op));
  }

  /// Reconciles the player with the latest wanted state (read when it runs,
  /// so bursts of changes collapse into the final one).
  Future<void> _reconcile() async {
    final audible = _wanted == _Music.playing && !_muted;
    if (audible) {
      await _loadMusic();
      if (_restartPending) {
        await _player.seek(Duration.zero);
        _restartPending = false;
      }
      if (!_playing) {
        await _player.resume();
        _playing = true;
      }
    } else if (_loaded && _playing) {
      await _player.pause();
      _playing = false;
    }
    if (_wanted == _Music.stopped && _loaded && !_restartPending) {
      await _player.seek(Duration.zero);
    }
  }

  void _update() => _enqueue(_reconcile);

  @override
  void startMusic() {
    _wanted = _Music.playing;
    _restartPending = true;
    _update();
  }

  @override
  void pauseMusic() {
    if (_wanted != _Music.playing) return;
    _wanted = _Music.paused;
    _update();
  }

  @override
  void resumeMusic() {
    if (_wanted != _Music.paused) return;
    _wanted = _Music.playing;
    _update();
  }

  @override
  void stopMusic() {
    _wanted = _Music.stopped;
    _restartPending = false;
    _update();
  }

  @override
  void setMuted(bool muted) {
    _muted = muted;
    _update();
  }
}

/// Silent implementation for tests.
class NoopAudioService implements AudioService {
  @override
  Future<void> preload() async {}
  @override
  void playFlap() {}
  @override
  void playScore() {}
  @override
  void playCrash() {}
  @override
  void startMusic() {}
  @override
  void pauseMusic() {}
  @override
  void resumeMusic() {}
  @override
  void stopMusic() {}
  @override
  void setMuted(bool muted) {}
}
