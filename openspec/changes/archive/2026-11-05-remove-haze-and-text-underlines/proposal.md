# Proposal

## Why

Two visual defects hurt readability. The pale oval "haze" shapes drifting in the background look like stray objects and confuse players. The menu, pause, game-over and loading screens show a yellow double underline under their text, which is Flutter's debug-style fallback for `Text` widgets that have no `Material` ancestor.

## What Changes

- Remove the drifting haze ovals from the background (drawing, scroll offset and related config constants).
- Give all overlay screens a transparent `Material` ancestor so the yellow underline no longer appears under any title or text.
- Update the parallax requirement so it no longer promises a haze layer.

## Capabilities

### New Capabilities

### Modified Capabilities
- `visual-style`: the layered parallax background no longer includes a haze layer.
- `ui-style`: overlay text is shown without any underline decoration.

## Impact

- `lib/game/components/background_component.dart`: remove haze paint, offset and oval drawing.
- `lib/core/game_config.dart`: remove `bgHazeParallax` and `hazeColor`.
- `lib/main.dart`: wrap the app content in a transparent `Material`.
- Tests: add a widget test that no underline decoration is rendered; adjust any test referencing haze (none found today).
- No gameplay, collision, scoring or audio changes.
