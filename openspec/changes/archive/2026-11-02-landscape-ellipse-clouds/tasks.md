# Tasks

## 1. Landscape shell

- [x] 1.1 Change `main.dart` to `setPreferredOrientations([landscapeLeft, landscapeRight])` and the manifest to `android:screenOrientation="sensorLandscape"`; verify with grep, and on the emulator that portrait is never shown and flipping between landscapes keeps the app and the run alive
- [x] 1.2 Update `GameConfig` world to 800x400 with a 50-unit ground, add `laneCount`, `cloudWidth`, `cloudHeight`, `maxCloudsPerGroup`, `firstGroupDistance`, rebalanced plane and scroll values (design decision 8), and delete the gap values; verify `flutter analyze` is clean and `grep -rn "gap" lib` finds no leftover gap config

## 2. Lane and ellipse logic

- [x] 2.1 Add `LanePicker` (injectable `Random`, 1 or 2 distinct lanes, never all three) and `test/lane_picker_test.dart` covering group size, lane variety, and that no group ever has three clouds; verify it passes
- [x] 2.2 Replace `CloudPairSpec` with `CloudSpec` (x, lane, derived centre and radii) and rework `CloudField` for groups, keeping distance-based spawning and off-screen removal; update `test/cloud_field_test.dart` for exact group spacing at small and large `dt`, first-group distance, three distinct lane centres and removal; verify it passes
- [x] 2.3 Rework `CollisionRules.hitsCloud` to the exact rect-vs-ellipse test; rewrite `test/collision_rules_test.dart` for: direct hit, passing over, passing under, bounding-box corner clip with no hit, plus ceiling and ground; verify it passes
- [x] 2.4 Add a config-sanity test that the plane hitbox fits above the top cloud, between neighbouring lane clouds, and below the bottom cloud; rewrite the bot simulation test (flap toward a free lane) to clear 30 groups across 20 seeds; verify both pass
- [x] 2.5 Delete `gap_generator.dart` and its test; verify `flutter analyze` and `flutter test` are clean with no dead references

## 3. Flame components

- [x] 3.1 Replace `CloudPairComponent` with `CloudComponent` (placeholder `drawOval`), update spawn and removal wiring in `FrightFlightGame`, and adjust `BackgroundComponent` for the new world; verify on the emulator that ellipses enter from the right, sit in three lanes and are removed off-screen
- [ ] 3.2 Verify on the emulator that hitting a cloud ellipse, the ground and the ceiling each end the run, that flying over and under a cloud does not, and that tap-to-restart still works

## 4. Docs and play-test

- [x] 4.1 Update `openspec/project.md` (orientation line and cloud wording in Purpose and Game rules) and verify no "portrait" or "cloud pair" text remains
- [ ] 4.2 Play-test on the emulator at two screen sizes (for example 2400x1080 and a 16:9 size via `wm size`), tune `GameConfig` only to make the game fair, and record final values in the change summary
- [x] 4.3 Run `dart format .`, `flutter analyze` and `flutter test`; verify all are clean with no TODOs and no dead code

## Workflow follow-up

- Archive the change after play-testing, then commit on `dev`.
