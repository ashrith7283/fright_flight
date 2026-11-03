# Proposal

## Why

The plane and sky feel static. A smoke trail behind the plane shows its motion and path, and a few birds in the distance make the sky feel alive.

## What Changes

- Add a smoke trail emitted from the back of the plane while a run is in progress: puffs spawn at the tail, drift left with the world, grow and fade, then disappear.
- Add a few small, dark bird silhouettes in the background that fly slowly across the sky with a wing-flap animation and wrap around.
- Both effects are purely cosmetic: no collisions, no score effects, no gameplay change.
- Smoke is cleared when a run is reset; birds are visually distinct from obstacle clouds (small, dark, high in the sky) so they cannot be mistaken for obstacles.

## Capabilities

### New Capabilities
- `smoke-and-birds`: The plane's smoke trail and the decorative background birds.

### Modified Capabilities
<!-- None. visual-style's "only clouds are obstacle clouds" still holds: birds are not clouds. -->

## Impact

- New `lib/game/components/smoke_trail.dart` and `lib/game/components/birds.dart` (or a birds section in the background), wired up in `lib/game/fright_flight_game.dart`.
- Constants in `lib/core/game_config.dart`.
- No new dependencies or assets.
- Out of scope: sound, birds as obstacles, smoke colour changes on crash, particle library.
