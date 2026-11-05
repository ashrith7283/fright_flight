import 'package:flutter/material.dart';

import '../game/logic/medals.dart';

/// Medal icon tinted for its tier, with the tier name.
class MedalBadge extends StatelessWidget {
  const MedalBadge({super.key, required this.medal, this.showLabel = true});

  final Medal medal;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '${medal.label} medal',
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.military_tech, color: medal.color, size: 24),
          if (showLabel) ...[
            const SizedBox(width: 4),
            Text(
              medal.label,
              style: TextStyle(
                color: medal.color,
                fontSize: 15,
                fontWeight: FontWeight.w900,
                letterSpacing: 3,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
