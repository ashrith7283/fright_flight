# Design

## Context

`core-gameplay` is archived and implemented: a portrait 400x800 world, pure-Dart logic in `lib/game/logic/` (`PlaneBody`, `CloudField`, `GapGenerator`, `CollisionRules`, `RunController`) and thin Flame components. Rules are axis-aligned rectangles and all tuning sits in `GameConfig`. See `proposal.md` for motivation and `specs/` for requirements.

## Goals / Non-Goals

**Goals:**
- Landscape-only play with the same logic/rendering split and the same `RunController`, `PlaneBody` and tap handling.
- Lane-based elliptical clouds with exact ellipse collision, all tunable from `GameConfig`.

**Non-Goals:**
- Hiding system bars (immersive mode), score, art, difficulty ramp.
- Per-cloud size variation or moving-in-lane behaviour.

## Decisions

**1. Landscape world is 800 x 400 with a 50-unit ground.**
`worldWidth = 800`, `worldHeight = 400`, `groundHeight = 50`, so the usable height is 350 (`groundTop = 350`). The fixed-resolution camera already letterboxes, so no other scaling code changes. Alternative: keep 400x800 and rotate the canvas. Rejected because input and layout would then be rotated by hand.

**2. Orientation lock.**
`SystemChrome.setPreferredOrientations([landscapeLeft, landscapeRight])` in `main.dart`, and `android:screenOrientation="sensorLandscape"` in the manifest so the lock holds before Dart starts and flipping between the two landscapes works. Alternative: `landscape` (no sensor flip). Rejected because players hold phones either way up.

**3. Lanes are derived, not stored.**
`GameConfig.laneCount = 3`. Lane height is `groundTop / laneCount` (about 116.7). Lane `i` centre is `(i + 0.5) * laneHeight`. No lane list in config, so changing `laneCount` or the world height keeps clouds centred.

**4. Cloud size leaves room to pass.**
Ellipse is `cloudWidth = 160` by `cloudHeight = 52`. Free space above the top-lane cloud and below the bottom-lane cloud is about 32, and between neighbouring lane clouds about 65. The plane is 48x30 with a 4-unit hitbox inset (22 high), so it fits in every one of those spaces. Rule to keep: `cloudHeight <= laneHeight - planeHitboxHeight - 2 * margin`. A unit test asserts the plane fits in all three kinds of free space with the shipped config.

**5. Spawning by group, still distance-based.**
`CloudField` keeps the existing distance-travelled spawn logic (exact spacing regardless of `dt`). `CloudPairSpec` becomes `CloudSpec` (x, lane). A new `LanePicker` (replacing `GapGenerator`, injectable `Random`) returns 1 or 2 distinct lanes, never all three (`maxCloudsPerGroup = 2`, asserted `< laneCount`). Group size is chosen uniformly between 1 and the max, then lanes are shuffled and taken. Alternative: independent per-lane coin flips with a re-roll if all three come up. Rejected because the re-roll makes the distribution and test less direct.

**6. Exact ellipse collision.**
`CollisionRules.hitsCloud(plane rect, cloud)`: clamp the ellipse centre to the plane rect to get the nearest point, then test `(dx/a)^2 + (dy/b)^2 < 1` with `a, b` the half-axes. Scaling each axis keeps the rectangle axis-aligned, so this is exact, not an approximation. Ceiling and ground checks are unchanged. Alternative: keep bounding boxes with a smaller hitbox. Rejected because spec requires ellipse overlap and corner clips must not count.

**7. Flame rendering.**
`CloudComponent` draws `canvas.drawOval` for its rect. Background draws sky and a 50-unit ground strip; sky colour still fills letterbox bars. `PlaneComponent` is unchanged apart from config values.

**8. Rebalanced physics.**
Starting values for a 350-unit play height, to be tuned on a device: `gravity = 1300`, `flapImpulse = 360` (peak about 50 units, under a lane), `maxFallSpeed = 600`, `scrollSpeed = 220`, `spawnSpacing = 460`, `firstGroupDistance = 300`, `planeStartX = 150`, plane start at mid-height. Plane size becomes 48x30. `GapGenerator` values (`gapSize`, margins, `maxGapShift`) are deleted, not left dead.

## Risks / Trade-offs

- [Tuning values are guesses for the new world] -> Reuse the bot simulation in tests (flap toward a free lane) as a fairness check, then tune on a device. Tuning is a one-file edit.
- [Two landscape directions may restart the activity and reset a run] -> `configChanges` in the manifest already covers orientation, so Flutter keeps the engine alive. Verify by flipping the emulator mid-run.
- [Landscape height is small, so system bars eat space] -> Accepted for now. Immersive mode is a separate change.
- [Free lane may be far from the plane] -> Spacing of 460 at speed 220 leaves about 1.15 s between one group clearing the plane and the next reaching it (360 left under 0.7 s, too little for a two-lane climb; found by the simulation test). Checked by the simulation test.

## Migration Plan

Replace in place, no data to migrate. Existing `core-gameplay` specs are updated on archive of this change. `openspec/project.md` is edited by hand in the tasks.
