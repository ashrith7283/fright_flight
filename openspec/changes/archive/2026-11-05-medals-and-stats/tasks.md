# Tasks

## 1. Medal logic

- [x] 1.1 Add the medal thresholds to `GameConfig` and a pure `Medals` (`forScore`, `next`) with a `Medal` enum; unit-test below bronze, exact thresholds, above platinum, and the next-medal points for each band

## 2. Runs played

- [x] 2.1 Add `readRunsPlayed`/`writeRunsPlayed` to `StorageService`, `SharedPreferencesStorageService` and the fake, with validation that matches the high score; extend `storage_service_test` for missing, negative and invalid values
- [x] 2.2 Load, increment and save `runsPlayed` in `ScoreKeeper.finishRun()` once per finished run; extend `score_keeper_test` for one write per run, no count for an abandoned run, and an in-memory value kept after a failed write

## 3. UI

- [x] 3.1 Show the run's medal and the next-medal hint on `GameOverPanel`; add widget tests for the no-medal, mid-band and Platinum cases and a small-landscape no-overflow check
- [x] 3.2 Show runs played and the best-score medal on `MainMenu` and wire the values through `FrightFlightGame` and `main.dart`; add widget tests for a fresh install and a Gold high score

## 4. Integration

- [x] 4.1 Run `dart format`, `flutter analyze` and `flutter test` and verify all pass
- [x] 4.2 Developer checks on a device that the panel and menu read clearly and fit the screen
