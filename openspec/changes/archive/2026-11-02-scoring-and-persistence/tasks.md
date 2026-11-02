# Tasks

## 1. Config and dependency

- [x] 1.1 Add `shared_preferences` to `pubspec.yaml` and run `flutter pub get`; verify it resolves and `flutter analyze` is clean
- [x] 1.2 Add score text tuning values to `GameConfig` (positions, font sizes, colour) and verify they compile and are used by name only

## 2. Cloud group identity

- [x] 2.1 Add `groupId` to `CloudSpec` and assign an increasing id per group in `CloudField.step`, resetting in `reset()`; verify existing cloud tests still pass
- [x] 2.2 Add `cloud_field_test.dart` cases: clouds of a group share an id, groups have distinct ids, ids restart after `reset()`; verify `flutter test test/cloud_field_test.dart` passes

## 3. Storage service

- [x] 3.1 Create `lib/services/storage_service.dart` with the `StorageService` interface and `SharedPreferencesStorageService`; verify it compiles
- [x] 3.2 Add `test/storage_service_test.dart` using `SharedPreferences.setMockInitialValues` for round trip, missing key (null) and wrong-type value; verify tests pass
- [x] 3.3 Add a `FakeStorageService` test helper that records writes and can throw on read or write; verify it is used by the next group's tests

## 4. Score logic (plain Dart)

- [x] 4.1 Implement `ScoreKeeper` in `lib/game/logic/score_keeper.dart`: watermark pass detection with `right < planeStartX`, `reset`, no scoring once finished; verify with tests for once-per-group, two-cloud group, multi-group step, boundary equality, reset
- [x] 4.2 Implement `load` with fallback to 0 for null, negative and thrown errors; verify with tests for fresh install, valid, negative and throwing read
- [x] 4.3 Implement `finishRun` (strictly-greater check, `newBest`, single guarded write, in-memory value kept on failure); verify with tests for new best, tie, lower, fresh install with score 0 and 1+, crash on first group, one write per run, no write during play, write failure then later success
- [x] 4.4 Add a pure text-formatting function for the play and game-over strings; verify with a unit test including the new best line present and absent

## 5. Game integration and display

- [x] 5.1 Wire `ScoreKeeper` into `FrightFlightGame`: constructor-injected `StorageService`, `load` in `onLoad`, pass detection only when still `playing` after the collision check, `finishRun` on the playing to game-over transition, `reset` in `_reset`; verify via a logic-level ordering test where possible
- [x] 5.2 Add the `ScoreHud` text component(s): hidden in ready, live score in playing, score, high score and new best in game over; verify manually on an emulator, including a crash on the first group, a tie, and a new best
- [x] 5.3 Verify manually that a denied or failing storage does not affect play (e.g. temporarily throwing fake) and that the high score persists after force-stopping and relaunching the app

## 6. Final checks

- [x] 6.1 Run `dart format .`, `flutter analyze` and `flutter test`; verify all pass with no warnings
- [x] 6.2 Run `openspec validate scoring-and-persistence --strict`; verify it reports valid

## Workflow follow-up

- Archive the change after review, then commit with a Conventional Commits message.
