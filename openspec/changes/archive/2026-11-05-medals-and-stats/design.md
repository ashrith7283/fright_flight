# Design

## Context

`StorageService` already stores the high score, mute and haptics settings with safe reads, and `ScoreKeeper.finishRun()` writes the high score once at game over without being awaited by the game loop. `GameOverPanel` takes `score`, `best` and `newBest` from `FrightFlightGame`. `MainMenu` shows a BEST pill with a trophy icon. Abandoning a run goes through `RunController.toMenu()`, which never calls `finishRun`. See proposal.md for motivation.

## Goals / Non-Goals

**Goals:**
- Medal rules as a pure, tested function of the score.
- The runs-played count follows the high-score storage pattern: one write per finished run, safe reads, failure-tolerant.

**Non-Goals:**
- Online leaderboards or achievements (out of scope for v1).
- Medal art assets. Medals use Material icons tinted per tier.

## Decisions

- **Thresholds in `GameConfig`**: Bronze 10, Silver 25, Gold 50, Platinum 100. They are reachable under the `gameplay-tuning` ramp (hard from 60), and Platinum stays aspirational.
- **`Medals.forScore(score) → Medal?`** and **`Medals.next(score) → (Medal, pointsNeeded)?`**, with an `enum Medal { bronze, silver, gold, platinum }` that carries a display name and a colour.
- **Runs played lives next to the high score**: a `runsPlayed` field in `ScoreKeeper`, loaded in `load()` and incremented and written in `finishRun()`. `finishRun()` is the one path that runs exactly once per finished run, so there is no new lifecycle hook. Alternative: a separate `RunStats` class. That was rejected as premature for one counter.
- **Storage key** `runs_played` (int), read with the same validation as the high score.
- **UI**: the panel adds a medal row (a `Icons.military_tech` tinted per tier, plus the name) and a small hint line ("12 MORE FOR SILVER"). The menu adds "RUNS N" and the best-score medal icon inside the existing BEST pill. Both must still fit small landscape phones without overflow, per the `ui-style` spec.
- **Wiring**: `FrightFlightGame` exposes `runsPlayed`, and `main.dart` passes it and the medal data to the overlays.

## Risks / Trade-offs

- [The panel gets crowded on short screens] → `FittedBox` already scales the panel, and the widget test runs on a small landscape size.
- [Count write races with the high-score write] → Both happen in the same `finishRun()` call, sequenced; failures are caught independently.
