import 'dart:ui';

import 'package:flutter/material.dart';

import '../core/game_config.dart';

/// Translucent, blurred, rounded card used by every screen. Fades and scales
/// in on first build; the animation never blocks input.
class GlassPanel extends StatelessWidget {
  const GlassPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(GameConfig.uiRadius);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: GameConfig.uiAnimation,
      curve: Curves.easeOutCubic,
      builder: (context, t, child) => Opacity(
        opacity: t,
        child: Transform.scale(scale: 0.92 + 0.08 * t, child: child),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: radius,
          boxShadow: const [
            BoxShadow(
              color: Color(0x40000000),
              blurRadius: 24,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: radius,
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: GameConfig.uiGlassBlur,
              sigmaY: GameConfig.uiGlassBlur,
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: GameConfig.uiGlassFill,
                borderRadius: radius,
                border: Border.all(color: GameConfig.uiGlassBorder),
              ),
              child: Padding(padding: padding, child: child),
            ),
          ),
        ),
      ),
    );
  }
}
