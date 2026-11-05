# Proposal

## Why

The only goal right now is beating your own best score. Once that best is high, most runs end with no sense of progress. Score medals give a nearer goal ("8 more for SILVER") and a reward for decent runs. A runs-played count lets players see how much they have played. Both are standard retention hooks for one-tap arcade games and need only local storage.

## What Changes

- Award a medal for each finished run by final score: Bronze, Silver, Gold or Platinum at configured thresholds, or none below Bronze.
- The game-over panel shows the run's medal and how many more points the next medal needs.
- Count runs played (finished runs only; abandoned runs do not count). Store the count locally, written once at game over.
- The main menu shows runs played and the medal earned by the best score.

## Capabilities

### New Capabilities
- `medals-and-stats`: medals awarded by score, the next-medal hint, the persisted runs-played count, and where these are shown.

### Modified Capabilities

## Impact

- New pure `Medals` logic in `lib/game/logic/`. `GameConfig` medal thresholds.
- `StorageService` gains `readRunsPlayed`/`writeRunsPlayed`. `SharedPreferencesStorageService` and `test/helpers/fake_storage_service.dart` are updated.
- `ScoreKeeper` (or a small `RunStats`) increments and saves the count at game over.
- `lib/ui/game_over_panel.dart`, `lib/ui/main_menu.dart`, `lib/main.dart` (pass the new values).
- Tests: new unit tests for medals and the stats store, and widget tests for the panel and the menu.
- No change to scoring rules, gameplay or audio. Independent of the other two changes.
