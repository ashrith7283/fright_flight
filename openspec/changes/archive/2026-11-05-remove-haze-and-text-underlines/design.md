# Design

## Context

The app uses `MaterialApp(home: PopScope(child: GameWidget(...)))` with Flame overlays built from plain `Text` widgets. There is no `Scaffold` or `Material` ancestor, so `Text` falls back to Flutter's default style: yellow double underline. The haze is drawn in `BackgroundComponent.render` as three `drawOval` calls per repeat tile, driven by `_hazeOffset`.

## Goals / Non-Goals

**Goals:**
- Remove haze ovals and their dead code/config.
- Remove the underline from every overlay text with one central fix.

**Non-Goals:**
- Redesigning other background layers or panel styling.

## Decisions

- **Wrap in a transparent `Material`** via `MaterialApp.builder` (`Material(type: MaterialType.transparency, child: child)`), rather than adding `decoration: TextDecoration.none` to each `TextStyle`. One change covers all current and future text, and fixes the cause. Alternative: per-style `decoration` — rejected as repetitive and easy to miss. Alternative: `Scaffold` — rejected, adds an opaque background and unneeded features.
- **Delete haze entirely** (paint, offset, update, oval loop, `bgHazeParallax`, `hazeColor`) instead of hiding it, to avoid dead code. Mountains remain as the far parallax layer.

## Risks / Trade-offs

- [Material ink/theme text styles may slightly change default font colour] → Overlay texts already set explicit styles; verify visually and via tests.
- [Existing `GlassIconButton` already uses its own `Material`] → Nested transparent Material is harmless.
