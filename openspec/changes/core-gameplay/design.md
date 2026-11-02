# Design

## Context

`fright_flight/` is the untouched `flutter create` counter app. `openspec/project.md` fixes the conventions: Flame engine, `lib/{core,game,ui,services}`, all tuning in one `GameConfig`, game logic separable from Flame so it can be unit tested, small files. See `proposal.md` for scope. Requirements are in `specs/`.

## Goals / Non-Goals

**Goals:**
- A playable loop that can be tuned by editing `GameConfig` only.
- Rules (physics step, collision, gap generation, state transitions) testable with plain `dart test`-style unit tests, no `FlameGame` instance.

**Non-Goals:**
- Score, persistence, menus, pause, art, audio, difficulty ramp.
- Pixel-perfect collision. Axis-aligned rectangles are enough for now.

## Decisions

**1. Pure-Dart logic layer, thin Flame layer.**
Pure classes in `lib/game/logic/`: `PlaneBody` (position and velocity, `step(dt)`, `flap()`), `CloudPairSpec` (x, gapTop, gapSize), `GapGenerator` (takes a `Random`), `CollisionRules` (rect overlap, bounds checks), `RunState` enum plus `RunController` (state transitions and restart delay). Flame components (`PlaneComponent`, `CloudPairComponent`, `BackgroundComponent`) read from or call into these and only draw. Alternative: put the rules in the components and test through `flame_test`. Rejected because it ties rules to the engine, against `project.md`.

**2. Own collision rules instead of Flame's collision system.**
With one plane and a few rectangles, an explicit `CollisionRules.hits(plane, pairs)` per frame is simpler, deterministic and trivial to unit test. Flame hitboxes and `HasCollisionDetection` add callbacks and ordering concerns for no gain here. Revisit if non-rectangular hitboxes come in `art-audio-polish`.

**3. Fixed virtual resolution.**
Use a fixed logical play area (`GameConfig.worldWidth` x `worldHeight`, portrait) via `CameraComponent.withFixedResolution`, letterboxed on unusual aspect ratios. All config distances are in these units, so tuning is device-independent (spec: Android portrait presentation). Alternative: use the raw canvas size. Rejected because gap and speed would feel different per phone.

**4. Time-based, frame-rate independent movement.**
Everything advances by `dt` from `update(dt)`. `dt` is clamped to `GameConfig.maxFrameDelta` so a hitch (or resume from background) cannot teleport the plane through a cloud.

**5. Spawning by distance, not timer.**
Track the x-position of the last spawned pair; spawn another when it has scrolled `spawnSpacing` away from the spawn edge. This gives exact spacing (spec) regardless of frame time.

**6. Gap generation.**
`GapGenerator.next(previousCentre)` picks the gap centre uniformly in `[ceilingMargin + gap/2, groundTop - groundMargin - gap/2]`, then clamps to `previousCentre ± maxGapShift` so consecutive gaps are always reachable with the configured flap and speed. `maxGapShift` and the margins are config values, verified by a unit test that simulates a flap path through generated pairs.

**7. Input.**
A `TapCallbacks` mixin on the game (full-screen) forwards `onTapDown` to `RunController.onTap()`, which dispatches by state: ready starts, playing flaps, gameOver restarts after the delay. Using tap-down, not tap-up, to minimise latency.

**8. App shell.**
`main.dart` sets `SystemChrome.setPreferredOrientations([portraitUp])`, hides nothing else, and runs `GameWidget`. The manifest also gets `android:screenOrientation="portrait"` so the lock holds before Dart starts. Placeholder art is drawn with `Canvas` rects, no assets.

**9. Config.**
`lib/core/game_config.dart` is a class of `static const` values: world size, ground height, plane size and start position, gravity, flap impulse, max fall speed, scroll speed, gap size, gap margins, `maxGapShift`, spawn spacing, first-pair distance, cloud width, restart delay, max frame delta. No raw numbers in game code.

## Risks / Trade-offs

- [Tuning values are guesses] → Start with values from a quick reference calculation (flap peak height well under half the gap) and tune on a device. Tuning is a one-file edit.
- [Rectangle collision feels unfair against rounded clouds] → Shrink the plane hitbox slightly via a config inset. Real hitboxes deferred to the art change.
- [Flame API drift from training-era examples] → Pin to `flame: ^1.38.2` and check calls against its docs while implementing.
- [Letterboxing on tall phones shows bars] → Acceptable for now. Sky colour fills the background so bars are unobtrusive.
