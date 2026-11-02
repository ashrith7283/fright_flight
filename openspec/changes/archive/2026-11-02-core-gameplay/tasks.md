# Tasks

Per `project.md`: run `dart format .`, `flutter analyze` and `flutter test` (from `fright_flight/`) before marking any task done. Commit after the change is complete, Conventional Commits style.

## 1. Setup

- [x] 1.1 Run `flutter pub add flame` in `fright_flight/` and verify `pubspec.yaml` lists `flame: ^1.38.x` and `flutter pub get` succeeds
- [x] 1.2 Lock portrait: `android:screenOrientation="portrait"` in `AndroidManifest.xml` and `SystemChrome.setPreferredOrientations` in `main.dart`; verify by grep and, on a device or emulator, that rotating does not rotate the app
- [x] 1.3 Create `lib/core/game_config.dart` with every tuning value named in design decision 9, and verify `flutter analyze` is clean

## 2. Pure game logic (with tests)

- [x] 2.1 Implement `PlaneBody` (gravity, max fall speed, `flap()` replaces velocity); add `test/plane_body_test.dart` covering the plane-control scenarios (fall, speed cap, flap replaces velocity, repeated taps do not stack), and verify it passes
- [x] 2.2 Implement `CollisionRules` (rect vs cloud, ceiling, ground, gap pass-through); add `test/collision_rules_test.dart` covering the run-lifecycle collision scenarios, and verify it passes
- [x] 2.3 Implement `GapGenerator` with an injectable `Random`; add `test/gap_generator_test.dart` covering margins, variation and `maxGapShift`, plus a simulation showing a flap path can clear consecutive generated gaps, and verify it passes
- [x] 2.4 Implement `RunState` and `RunController` (ready to playing to gameOver to ready, restart delay, tap dispatch); add `test/run_controller_test.dart` covering start, freeze after crash, tap ignored during the delay and restart after it, and verify it passes
- [x] 2.5 Implement distance-based pair spawning and removal in a pure `CloudField` (spacing, first-pair distance, off-screen removal, `dt`-independent scroll); add `test/cloud_field_test.dart`, and verify it passes with both small and large `dt` steps

## 3. Flame layer

- [x] 3.1 Create `FrightFlightGame` using a fixed-resolution camera sized from `GameConfig`, clamped `dt`, and full-screen tap input forwarded to `RunController`; verify the app launches and shows an empty sky and ground in portrait
- [x] 3.2 Add `BackgroundComponent` and `PlaneComponent` (placeholder rect art) driven by `PlaneBody`; verify on device that the plane idles in ready, falls after the first tap and lifts on each further tap
- [x] 3.3 Add `CloudPairComponent` (placeholder art) driven by `CloudField`, with spawn and removal wired into the game loop; verify pairs scroll at the configured speed with randomised gaps and are removed off-screen
- [x] 3.4 Wire collision checks and the game-over freeze and tap-to-restart; verify on device that hitting a cloud, the ground and the ceiling each end the run, the scene freezes, and a tap after the delay restarts
- [x] 3.5 Replace `main.dart` with the `GameWidget` shell and delete the stock `test/widget_test.dart`; verify `flutter analyze` and `flutter test` pass with no leftover counter-app code

## 4. Integration

- [x] 4.1 Play-test on an Android device or emulator across at least two screen sizes; verify against every spec scenario, adjust `GameConfig` only to make the game fair, and note final values and anything deferred in the change summary
- [x] 4.2 Final `dart format .`, `flutter analyze`, `flutter test` all clean; verify no TODOs without a spec reference and no dead code remain

## Workflow follow-up

- Review the artifacts, then run `/opsx:apply`.
- Archive the change with `/opsx:archive` after device play-testing, then commit (`feat: core gameplay`).
