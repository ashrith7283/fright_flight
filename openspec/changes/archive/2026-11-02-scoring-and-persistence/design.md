# Design

## Context

The core loop (see proposal.md) is split into plain-Dart logic in `lib/game/logic/` and Flame components in `lib/game/components/`; `FrightFlightGame.update` steps the plane and `CloudField`, then checks `CollisionRules.hits`, then calls `RunController.crash()`. `CloudSpec` has no group concept today: a group is just clouds spawned in the same `CloudField.step` loop sharing an `x`. `CloudSpec.right` is the cloud's trailing edge. The plane's visual left edge is `GameConfig.planeStartX`. `lib/services/` does not exist yet and no storage code exists.

## Goals / Non-Goals

**Goals:**
- Score and high-score rules are plain Dart, unit tested with a fake storage and no Flame.
- Storage faults are absorbed at one boundary and never reach gameplay.

**Non-Goals:**
- State management beyond the game object (no Riverpod or `ChangeNotifier`); that belongs with `screens-and-flow`.
- Any visual polish or layout system for the text.

## Decisions

### Pass detection: group id plus a watermark
`CloudField` assigns each group an increasing integer `groupId` (reset to 0 in `reset()`), stored on every `CloudSpec` of that group. `ScoreKeeper.onCloudsAdvanced(clouds)` awards a point per distinct `groupId` greater than its `_lastCountedGroupId` whose `cloud.right < GameConfig.planeStartX`, then moves the watermark up to the highest such id.

Because groups spawn in id order and all scroll at the same speed, they pass the plane in id order, so one integer replaces a set of counted ids and a large frame step still counts every group passed. Using the group's right edge (both clouds of a group share `x` and width) gives the trailing-edge rule from the spec. The rule is a strict `<`, so a group exactly touching the plane's left edge is not yet passed.

Alternatives: a `Set<int>` of counted ids (more state, same result); firing on a component callback or Flame collision hitbox (ties scoring to rendering, harder to test); inferring groups by matching `x` (fragile, rejected). This is the reason `cloud-obstacles` is touched: the identity is a behaviour that scoring relies on, and it is a minimal addition to `CloudSpec`/`CloudField`.

### Update order and the crash frame
In `FrightFlightGame.update` the order is: step plane and clouds, collision check, and only if the run is still `playing` call the pass detector. A crash in the same step therefore awards nothing, and the `playing` guard also covers "no score after the run has ended". Scoring is skipped by `ScoreKeeper` itself once finished, as a second guard.

### Where score state lives
`ScoreKeeper` (plain Dart, `lib/game/logic/score_keeper.dart`) owns `score`, `highScore`, `newBest` and the watermark. API sketch: `Future<void> load()`, `int onCloudsAdvanced(Iterable<CloudSpec>)`, `Future<void> finishRun()`, `void reset()`. The game owns one instance, created with a `StorageService`. `reset()` is called from the game's existing `_reset` hook (restart). `newBest` is true only when `finishRun` saw `score > highScore`; it is cleared by `reset()`. Score text components read these values; they hold no state of their own.

### Storage interface
`lib/services/storage_service.dart`:
- `abstract class StorageService { Future<int?> readHighScore(); Future<void> writeHighScore(int value); }`
- `SharedPreferencesStorageService` implements it with one key constant (not a tuning value, so not in `GameConfig`).

Sanitising is `ScoreKeeper`'s job, not the service's, so it is tested against the fake: `load()` treats `null`, negative and thrown errors as 0. A wrong-type value makes `SharedPreferences.getInt` throw, which lands in the same catch. The service obtains `SharedPreferences.getInstance()` inside each call, so even a failing instance lookup is an ordinary caught exception rather than a launch crash, and `main.dart` needs no async setup beyond constructing the service. The game is given the service by constructor (default: the real one) so tests inject a fake.

### Persistence timing and failures
`load()` runs in the game's `onLoad`, which Flame awaits before the first update, so the ready state always has the loaded value. `finishRun()` runs once when the game observes the `playing` to `gameOver` transition. If `score > highScore` it sets `highScore` and `newBest` in memory first, then attempts one write inside try/catch and swallows the error. The game does not await the write before showing game over, so the UI is never blocked, and a failed write leaves the in-memory value correct for the session. The next new best simply attempts a fresh write (no retry queue). Ties and lower scores, including 0 on a fresh install, perform no write.

Alternative: save on every increment. Rejected by decision: many writes per run for little benefit; a mid-run process kill losing one run is acceptable.

### Display
Plain Flame `TextComponent`s added to the world (a `ScoreHud` component under `lib/game/components/`), toggled by `runState`: hidden in `ready`, live score in `playing`, and score, high score and conditional "new best" lines in `gameOver`. Positions, font sizes and the colour go in `GameConfig` (e.g. `scoreTextPosition`, `scoreFontSize`, `gameOverFontSize`). Text content strings are built by a small pure function so formatting can be unit tested.

### Test strategy
- `ScoreKeeper` with a `FakeStorageService` (records writes, can be told to throw on read or write): pass counting (once per group, two-cloud group, multi-group step, boundary equality), reset, crash on first group, no scoring after finish, new best, tie, lower, fresh install with 0 and with 1+, one write per run, no write during play, missing/negative/throwing read, throwing write keeps in-memory value and retries next time.
- `CloudField`: group ids shared within a group, distinct across groups, reset on `reset()`.
- A step-level test that combines `CloudField`, `ScoreKeeper` and `CollisionRules` to cover the pass-and-crash-in-one-update ordering where it is expressible without Flame; the rest of the ordering is verified manually.
- `SharedPreferencesStorageService` with `SharedPreferences.setMockInitialValues` for round trip and wrong-type values.
- HUD text and layout are not unit tested; verified manually on an Android device or emulator.

## Risks / Trade-offs

- Process killed mid-run loses that run's score → accepted by the save-on-game-over decision.
- Fire-and-forget write races a very fast restart → the write is independent of run state and uses the value captured at game over, so a restart cannot change what is written.
- Watermark assumes groups pass in id order → true while scroll speed is uniform. A future per-group speed or difficulty change must revisit it; noted here for the difficulty change.
- `lib/services/` imports `shared_preferences` only in the concrete class, keeping logic files free of platform packages.
