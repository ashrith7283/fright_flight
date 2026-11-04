import 'package:flutter/material.dart';

import '../core/game_config.dart';

/// Rounded pill button with an icon and label. The primary action is filled
/// with the accent colour; the secondary one is a translucent outline. A null
/// [onPressed] disables it.
class PillButton extends StatelessWidget {
  const PillButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.primary = true,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool primary;

  static const _shape = StadiumBorder();
  static const _size = Size(132, 48);
  static const _text = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w800,
    letterSpacing: 1.5,
  );

  @override
  Widget build(BuildContext context) {
    final iconWidget = Icon(icon, size: 22);
    final text = Text(label.toUpperCase());
    if (primary) {
      return FilledButton.icon(
        onPressed: onPressed,
        icon: iconWidget,
        label: text,
        style: FilledButton.styleFrom(
          backgroundColor: GameConfig.uiAccent,
          foregroundColor: Colors.white,
          disabledBackgroundColor: GameConfig.uiAccent.withValues(alpha: 0.35),
          disabledForegroundColor: Colors.white54,
          minimumSize: _size,
          shape: _shape,
          textStyle: _text,
          elevation: 3,
        ),
      );
    }
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: iconWidget,
      label: text,
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0x26FFFFFF),
        disabledForegroundColor: Colors.white38,
        side: BorderSide(
          color: onPressed == null ? Colors.white24 : GameConfig.uiGlassBorder,
        ),
        minimumSize: _size,
        shape: _shape,
        textStyle: _text,
      ),
    );
  }
}
