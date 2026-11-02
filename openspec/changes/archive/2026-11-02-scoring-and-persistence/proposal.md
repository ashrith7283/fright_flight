# Proposal

## Why

The core loop has no goal beyond surviving. Roadmap item 2 adds the score and a persisted high score, so a run has a result worth beating and the player has a reason to retry.

## What Changes

- Score +1 each time the plane passes a cloud group, once per group. A group is passed when its trailing (right) edge is left of the plane's trailing (left) visual edge, `GameConfig.planeStartX`. A crash in the same frame as the pass awards no point.
- Score resets to 0 on each new run and never changes after the run ends.
- High score is loaded at launch and saved on game over only, when the final score is strictly greater than the stored value. Missing, corrupt or negative stored values fall back to 0. Read and write failures never interrupt play.
- New `StorageService` in `lib/services/` wrapping `shared_preferences` behind an interface, so scoring is testable with a fake. Add the `shared_preferences` dependency.
- Minimal Flame text: a placeholder score readout while playing; score, high score and a "new best" line on game over. The readout is hidden in the ready state.
- Cloud groups gain a stable group identity so a pass is counted once per group (see `cloud-obstacles` delta).
- New `GameConfig` values for the text layout, referenced in specs by name.

Out of scope: difficulty ramp, sound, haptics, ads, leaderboards, settings screen, reset-high-score UI, menus, pause, polish and art.

## Capabilities

### New Capabilities
- `scoring`: score counting per cloud group, high score comparison, persistence with fallback and failure tolerance, and the score and high-score text shown in play and game over.

### Modified Capabilities
- `run-lifecycle`: restart resets the score; the game-over state shows the score, the high score and a "new best" indication.
- `cloud-obstacles`: each spawned group carries a stable identity shared by its clouds, which the pass rule depends on. No change to size, lanes, speed, spacing or free-lane behaviour. `plane-control` is untouched.

## Impact

- New: `lib/services/storage_service.dart` (interface plus `shared_preferences` implementation), plain-Dart score logic under `lib/game/logic/`, and unit tests with a fake storage.
- Changed: `CloudSpec` and `CloudField` (group id), `FrightFlightGame` (wire score, load and save, text components), `main.dart` (inject storage), `GameConfig`, `pubspec.yaml`.
- Dependency: `shared_preferences`. Android only.
