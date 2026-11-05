# Design

## Context

Current logic: `DifficultyCurve.speedFor` (220 + 1/pt, cap 260); `CloudField.step` spawns every fixed `spawnSpacing` (460) of distance; `LanePicker.pick` draws 1 or 2 clouds with equal odds; `CloudSpec.centreY` is the fixed lane centre; `CollisionRules.hitsBounds` treats `top <= 0` as a hit; `PlaneBody` is only stepped while playing; the ready HUD shows only the best score. `lane_fit_and_simulation_test` already flies a rate-limited bot through 30 groups on 20 seeds at base and max speed. See proposal.md for motivation.

## Goals / Non-Goals

**Goals:**
- One shared ramp parameter (score 0 → `rampEndScore`) drives speed, spacing and two-cloud share.
- Every new rule is pure logic, unit-tested, and the bot simulation still clears runs at the hardest settings.

**Non-Goals:**
- Scoring, audio, visual style of clouds, game-over feel (separate `game-feel` change).

## Decisions

- **Config values (moderate)**: `rampEndScore = 60`; speed 220 → `maxScrollSpeed = 300` (`scrollSpeedPerPoint = 80/60`); spacing `spawnSpacing = 460` → `minSpawnSpacing = 380`; two-cloud share 0.5 → 0.8; `movingCloudScore = 50`, `movingCloudChance = 0.35`, `movingCloudAmplitude = 18`, `movingCloudPeriod = 2.4 s`; `hoverAmplitude = 6`, `hoverPeriod = 1.6 s`. Specs reference names; numbers stay tunable.
- **`DifficultyCurve` grows** `spacingFor(score)` and `twoCloudShare(score)` alongside `speedFor`, all using a clamped `t = min(score, rampEndScore) / rampEndScore`.
- **Spacing applied at spawn time**: `CloudField.step` takes the current spacing (like it takes speed) and sets `_nextSpawnAt += spacing` after each spawn, so already-placed groups never shift.
- **`LanePicker.pick(twoCloudShare)`** uses the share instead of `nextInt(maxCloudsPerGroup)`; deterministic with a seeded `Random`.
- **Moving clouds in `CloudSpec`**: optional `phase` and `moving` flag; `centreY` becomes lane centre + `amplitude * sin(phase + 2π·age/period)` where `age` advances only in `CloudField.step` (so pause/game over freeze it). Only single-cloud groups may move, which keeps two free lanes next to any moving cloud. Amplitude 18 leaves the cloud inside its lane ((117 − 52)/2 ≈ 32).
- **Soft ceiling in `PlaneBody.step`**: after integrating, if the hitbox top would be above 0, clamp `y` and set `velocity = max(velocity, 0)`. `CollisionRules.hitsBounds` keeps only the ground check. Alternative (bounce down) rejected: feels jarring.
- **Hover**: in the ready state the game sets `_body.y = planeStartY + hoverAmplitude·sin(2π·t/hoverPeriod)` and `velocity = 0`; the first flap starts from that `y`. No collisions are evaluated in ready, so this is safe.
- **Prompt**: a small Flame text component (or `ScoreHud` branch) drawing "TAP TO FLY" below the plane with an alpha pulse, rendered only in `RunState.ready`.
- **Fairness proof**: extend the bot simulation to run at `maxScrollSpeed` with `minSpawnSpacing`, max two-cloud share and moving clouds on, plus the soft ceiling. If it fails, raise `minSpawnSpacing` (not lower speed) until it passes, and record the final value.

## Risks / Trade-offs

- [380 spacing at speed 300 may be too tight for top↔bottom switches] → Simulation gate decides the final `minSpawnSpacing`; developer tunes by feel on device.
  **Result (apply):** at speed 300 the bot crashed on two-lane zig-zags (two-cloud group forcing the top lane, then one forcing the bottom) at 380, 400 and 420. It clears all 20 seeds at **440**, so `minSpawnSpacing = 440`. Most of the extra difficulty therefore comes from speed (220→300), the two-cloud share (0.5→0.8) and moving clouds, not from spacing.
- [Soft ceiling makes hugging the top a safe strategy] → Clouds in the top lane still block; two-cloud share rising reduces the safe path. Revisit if playtests show it.
- [Changing a spec'd rule (ceiling)] → Called out as BREAKING in the proposal; existing ceiling tests are rewritten, not deleted.
- [Hover changes the run's start height slightly] → Within ±6 units; simulation starts from `planeStartY`, still valid.
