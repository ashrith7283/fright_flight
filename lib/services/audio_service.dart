import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';

import '../game/logic/round_robin.dart';

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

/// One sound effect played through a few low-latency (SoundPool) voices that
/// are created and loaded once, then reused round-robin. A play only restarts
/// a voice, so a tap never creates, loads or releases a player. Voices live
/// for the whole app run, so there is no dispose.
class _EffectVoices {
  _EffectVoices._(this._voices) : _order = RoundRobin(_voices.length);

  final List<AudioPlayer> _voices;
  final RoundRobin _order;

  static Future<_EffectVoices> load(
    String file,
    int count,
    AudioContext context,
  ) async {
    final voices = <AudioPlayer>[];
    for (var i = 0; i < count; i++) {
      final p = AudioPlayer()..audioCache = FlameAudio.audioCache;
      await p.setPlayerMode(PlayerMode.lowLatency);
      await p.setAudioContext(context);
      await p.setReleaseMode(ReleaseMode.stop);
      await p.setSource(AssetSource(file));
      voices.add(p);
    }
    return _EffectVoices._(voices);
  }

  Future<void> play() async {
    final voice = _voices[_order.next()];
    await voice.stop(); // restart from the beginning if still sounding
    await voice.resume();
  }
}

/// Real audio. Built to stay fast over many runs: effects use pre-loaded
/// low-latency [_EffectVoices] and the music uses one persistent player (the
/// source is loaded once; stop/start only seek), instead of creating a player
/// per sound. Music commands are serialised so they cannot race or pile up.
class FlameAudioService implements AudioService {
  static const _flap = 'flap.wav';
  static const _score = 'score.wav';
  static const _crash = 'crash.wav';
  static const _music = 'music.m4a';
  static const _musicVolume = 0.5;

  static final _context = AudioContextConfig(
    focus: AudioContextConfigFocus.mixWithOthers,
  ).build();

  _EffectVoices? _flapVoices;
  _EffectVoices? _scoreVoices;
  _EffectVoices? _crashVoices;
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
      _flapVoices = await _EffectVoices.load(_flap, 3, _context);
      _scoreVoices = await _EffectVoices.load(_score, 2, _context);
      _crashVoices = await _EffectVoices.load(_crash, 1, _context);
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

  void _effect(_EffectVoices? voices) {
    if (_muted || voices == null) return;
    _safe(voices.play);
  }

  @override
  void playFlap() => _effect(_flapVoices);
  @override
  void playScore() => _effect(_scoreVoices);
  @override
  void playCrash() => _effect(_crashVoices);

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
