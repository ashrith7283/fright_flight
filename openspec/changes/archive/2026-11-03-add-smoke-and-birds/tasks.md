# Tasks

## 1. Constants

- [x] 1.1 Add smoke (spawn interval, lifetime, start/end radius, colour) and bird (count, positions, speeds, flap rate, wingspan, colour) constants to `lib/core/game_config.dart`

## 2. Smoke trail

- [x] 2.1 Create `lib/game/components/smoke_trail.dart`: emits puffs at the plane tail while running, moves them left at the scroll speed, grows and fades them, removes dead ones, freezes when not running
- [x] 2.2 Add it to the world in `lib/game/fright_flight_game.dart` below the plane, and clear it from `_reset`

## 3. Birds

- [x] 3.1 Draw flapping bird silhouettes with wrap-around in the upper sky of the background (new component or in `background_component.dart`), still when not running

## 4. Tests and verification

- [x] 4.1 Add a unit test for the smoke puff lifecycle (spawn rate, fade, removal, reset clears) using logic separated from the Canvas drawing
- [x] 4.2 Run `flutter analyze` and `flutter test`; confirm collisions and scoring are unchanged
- [x] 4.3 Run the app and visually check smoke and birds in ready, running, paused and game-over states
