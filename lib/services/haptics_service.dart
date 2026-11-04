import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Vibration feedback. Implementations must never throw: a missing motor or a
/// platform error must not reach gameplay.
abstract class HapticsService {
  void flap();
  void score();
  void crash();

  /// While disabled nothing vibrates.
  void setEnabled(bool enabled);
}

class FlutterHapticsService implements HapticsService {
  bool _enabled = true;

  void _run(Future<void> Function() action) {
    if (!_enabled) return;
    action().catchError((Object e) {
      debugPrint('Haptics error: $e');
    });
  }

  @override
  void flap() => _run(HapticFeedback.lightImpact);
  @override
  void score() => _run(HapticFeedback.selectionClick);
  @override
  void crash() => _run(HapticFeedback.heavyImpact);

  @override
  void setEnabled(bool enabled) => _enabled = enabled;
}

/// Silent implementation for tests.
class NoopHapticsService implements HapticsService {
  @override
  void flap() {}
  @override
  void score() {}
  @override
  void crash() {}
  @override
  void setEnabled(bool enabled) {}
}
