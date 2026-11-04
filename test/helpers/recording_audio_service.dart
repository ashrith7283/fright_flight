import 'package:fright_flight/services/audio_service.dart';

/// Records every call so tests can assert on sound behaviour.
class RecordingAudioService implements AudioService {
  final List<String> calls = [];
  bool? lastMuted;

  int count(String name) => calls.where((c) => c == name).length;

  @override
  Future<void> preload() async => calls.add('preload');
  @override
  void playFlap() => calls.add('flap');
  @override
  void playScore() => calls.add('score');
  @override
  void playCrash() => calls.add('crash');
  @override
  void startMusic() => calls.add('startMusic');
  @override
  void pauseMusic() => calls.add('pauseMusic');
  @override
  void resumeMusic() => calls.add('resumeMusic');
  @override
  void stopMusic() => calls.add('stopMusic');
  @override
  void setMuted(bool muted) {
    lastMuted = muted;
    calls.add('muted:$muted');
  }
}
