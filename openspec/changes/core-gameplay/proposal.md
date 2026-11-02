# Proposal

## Why

Fright Flight has only the stock Flutter counter app. Every later change (scoring, screens, ads, polish) builds on a playable core loop, so this is the first roadmap item (`core-gameplay` in `openspec/project.md`).

## What Changes

- Add the `flame` dependency (current stable, 1.38.x) to `fright_flight/pubspec.yaml`.
- Replace the stock counter app with a Flame game hosted in a `GameWidget`.
- Lock the app to portrait on Android. No iOS work.
- Add a plane that falls under gravity and gets an upward impulse on each tap.
- Add scrolling cloud pairs (top and bottom) with a randomised vertical gap, spawned at a fixed spacing and removed once off-screen.
- End the run immediately when the plane hits a cloud, the ground or the ceiling.
- Add three run states, `ready` (tap to start), `playing`, `gameOver` (tap to restart), so the loop is playable end to end. Menus, pause and game-over screens stay in `screens-and-flow`.
- Put every tuning value (gravity, flap impulse, scroll speed, gap size, gap bounds, spawn spacing, plane size) in a single `GameConfig`.
- Keep collision rules, gap generation and run-state transitions in plain Dart classes with unit tests, separate from Flame rendering.
- Draw plane, clouds, ground and sky as simple placeholder shapes. No image assets yet.

**Out of scope** (later roadmap changes): score and high score, storage, menus, pause, game-over screen, difficulty ramp, art, audio, haptics, ads, release config.

## Capabilities

### New Capabilities
- `plane-control`: the plane's vertical motion, with gravity, a tap-to-flap impulse and the ceiling and ground bounds.
- `cloud-obstacles`: scrolling cloud pairs, with randomised gap position, fixed spacing and removal off-screen.
- `run-lifecycle`: ready, playing and game-over states, collision-ends-run rule, tap-to-start and tap-to-restart, portrait Android play.

### Modified Capabilities
<!-- None: openspec/specs is empty. -->

## Impact

- `fright_flight/pubspec.yaml`: new `flame` dependency.
- `fright_flight/lib/main.dart`: replaced. New code under `lib/core/`, `lib/game/` per project conventions.
- `fright_flight/test/`: the stock `widget_test.dart` is replaced by unit tests for the game logic.
- `fright_flight/android/`: portrait orientation lock in `AndroidManifest.xml`. Min SDK is left to the Flutter default; the `google_mobile_ads` bump belongs to the `ads` change.
