import 'package:flutter/material.dart';

import '../core/game_config.dart';

/// Round glass icon button (48 dp touch target) with an accessible label.
class GlassIconButton extends StatelessWidget {
  const GlassIconButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: Tooltip(
        message: label,
        child: SizedBox(
          width: 48,
          height: 48,
          child: Material(
            color: GameConfig.uiGlassFill,
            shape: CircleBorder(
              side: BorderSide(color: GameConfig.uiGlassBorder),
            ),
            child: InkResponse(
              onTap: onPressed,
              customBorder: const CircleBorder(),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
          ),
        ),
      ),
    );
  }
}
