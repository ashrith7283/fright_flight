import 'package:fright_flight/services/haptics_service.dart';

class RecordingHapticsService implements HapticsService {
  final List<String> calls = [];
  bool? lastEnabled;

  int count(String name) => calls.where((c) => c == name).length;

  @override
  void flap() => calls.add('flap');
  @override
  void score() => calls.add('score');
  @override
  void crash() => calls.add('crash');
  @override
  void setEnabled(bool enabled) {
    lastEnabled = enabled;
    calls.add('enabled:$enabled');
  }
}
