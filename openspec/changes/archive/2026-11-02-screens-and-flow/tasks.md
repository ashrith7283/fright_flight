# Tasks

## 1. Run state and controller (plain Dart)

- [x] 1.1 Extend `RunState` with `menu` and `paused`, start in `menu`, and add `play`, `pause`, `resume`, `toMenu`, `restart` and `canRestart` to `RunController`; make `onTap` ignore `menu` and `paused`; verify `flutter analyze` is clean after fixing exhaustive switches (`ScoreHud`)
- [x] 1.2 Add tests in `run_controller_test.dart`: launch is `menu`; play goes to ready; pause and resume round trip; taps ignored in menu and paused; pause only from playing; `toMenu` from ready, paused and game over resets the scene; restart timer does not advance while paused; `canRestart` flips after `restartDelay`; verify `flutter test test/run_controller_test.dart` passes
- [x] 1.3 Add `lib/game/logic/back_action.dart` with `backActionFor(RunState)` and a test covering every state; verify the test passes

## 2. Game integration

- [x] 2.1 Wire the new transitions into `FrightFlightGame` (`play`, `pause`, `resume`, `toMenu`, `restart`) and add `_syncOverlays()` that maps state to the overlay set after every transition; verify no run logic changes with the existing logic tests passing
- [x] 2.2 Confirm `toMenu` and `restart` reset the scene and score, and that abandoning a run never calls `finishRun`; verify with a logic test using `FakeStorageService` (no write on abandon)
- [x] 2.3 Override `lifecycleStateChange` to pause when leaving the foreground during `playing`; verify with a unit-level check of the state decision where possible
- [x] 2.4 Update `ScoreHud` for the new states (hidden in `menu`, live score in `paused`); verify existing score text tests still pass

## 3. UI overlays

- [x] 3.1 Create `lib/ui/main_menu.dart` (title, Play, high score read when built); verify it renders in a widget test with a fake game
- [x] 3.2 Create `lib/ui/pause_button.dart` and `lib/ui/pause_menu.dart` (Resume, Menu); verify pressing them calls the game methods in a widget test
- [x] 3.3 Create `lib/ui/game_over_actions.dart` (Restart, Menu), positioned below the game-over text via a `GameConfig` anchor; verify in a widget test
- [x] 3.4 Update `main.dart`: `overlayBuilderMap`, `initialActiveOverlays: ['mainMenu']`, `PopScope` calling `backActionFor` with `SystemNavigator.pop()` for exit; verify `flutter analyze` is clean

## 4. Verification

- [x] 4.1 Run `dart format`, `flutter analyze` and `flutter test`; verify all pass
- [x] 4.2 On the emulator verify: launch shows the menu; Play starts ready; pause freezes and a tap while paused does nothing; Resume continues with no jump; Home during play shows the pause overlay on return; game-over buttons appear after the delay; Restart and Menu work; back button follows the spec in every state; high score updates on the menu
- [x] 4.3 Verify on the emulator that pressing the pause button does not flap the plane and that abandoning a high-scoring run via Menu leaves the high score unchanged
