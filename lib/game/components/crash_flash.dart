import 'dart:ui';

import 'package:flame/components.dart';

import '../logic/crash_effects.dart';

/// White full-screen flash drawn over the world after a crash.
class CrashFlash extends Component {
  CrashFlash(this.effects) : super(priority: 100);

  final CrashEffects effects;
  final Paint _paint = Paint();

  // Oversized like the background, so letterbox areas flash too.
  static const _area = Rect.fromLTWH(-2000, -2000, 4800, 4400);

  @override
  void render(Canvas canvas) {
    final a = effects.flashAlpha;
    if (a <= 0) return;
    _paint.color = Color.fromRGBO(255, 255, 255, a);
    canvas.drawRect(_area, _paint);
  }
}
