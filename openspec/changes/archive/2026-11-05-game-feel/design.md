# Design

## Context

`ScoreHud` renders the score with a cached `TextPaint`. `FrightFlightGame.update` steps `_body` only while playing, and calls `_transition(_run.crash)` on a hit. `CollisionRules.hitsCloud` already computes the normalised ellipse value `dx² + dy²` at the hitbox point nearest the cloud centre (value < 1 means a hit). The camera uses `CameraComponent.withFixedResolution`. `ScoreKeeper.onCloudsAdvanced` returns the number of groups passed per update. See proposal.md for motivation.

## Goals / Non-Goals

**Goals:**
- All effects are time-based components driven by `dt`, so they pause with the game and reset on restart.
- The near-miss rule is pure logic and unit-tested.

**Non-Goals:**
- Sounds or haptics for near misses (possible later).
- Particle systems or new art assets.

## Decisions

- **Config**: `scorePopScale = 1.35`, `scorePopDuration = 0.25 s`, `crashShakeAmplitude = 6`, `crashShakeDuration = 0.35 s`, `crashFlashAlpha = 0.6`, `crashFlashDuration = 0.2 s`, `nearMissMargin = 1.6` (normalised ellipse value; 1.0 is touching), `nearMissLabelDuration = 0.6 s`.
- **Score pop** in `ScoreHud`: keep a `_popT` timer reset on score change. Scale the canvas around the text anchor by an ease-out curve. `ScoreHud` already reads the score each frame, so a change is detected by comparing with the last value.
- **Crash shake**: offset `camera.viewfinder.position` by a random direction times amplitude × (1 − t/duration), then restore it exactly at the end. Skip it when `MediaQuery.disableAnimations` is true. The flag is read once from the game's build context and passed in.
- **Flash**: a full-viewport rectangle component above the world with alpha decaying to 0, removed when done.
- **Crash fall**: in `gameOver`, keep calling `_body.step(dt)` until the hitbox bottom reaches `groundTop`, then clamp. Collisions are not checked in game over. `PlaneComponent` already tilts by velocity, so the nose drops naturally. Restart resets the body as today.
- **Near miss**: `CollisionRules.proximity(rect, cloud)` returns the same normalised value without the `< 1` test. `NearMissTracker` keeps the minimum value per `groupId` while any cloud of that group overlaps the plane horizontally. When `ScoreKeeper` reports the group passed and no crash happened that update, it emits an event if min < `nearMissMargin`. It is cleared on reset. The game adds a short-lived label component at the plane on each event.
- **Ordering with `gameplay-tuning`**: moving clouds change `centreY` over time, and `proximity` uses the current value, so the tracker works unchanged.

## Risks / Trade-offs

- [Shake could feel bad or cause motion discomfort] → Small amplitude, short duration, respects reduced motion.
- [Margin 1.6 may trigger too often or too rarely] → Single config value, tuned on device.
- [Falling plane overlaps the game-over panel visually] → The panel is centred and translucent; the plane rests at the ground below it.
