# Tasks

## 1. Difficulty ramp

- [x] 1.1 Add ramp config (`rampEndScore`, new `maxScrollSpeed`, `scrollSpeedPerPoint`, `minSpawnSpacing`, two-cloud base/max share) to `GameConfig` and `spacingFor`/`twoCloudShare` to `DifficultyCurve`; update `difficulty_curve_test` for speed, spacing and share at 0, mid-ramp, ramp end and beyond
- [x] 1.2 Make `CloudField.step` take the current spacing and apply it at spawn time; add `cloud_field_test` cases for steady spacing at a fixed score, shrinking spacing and the floor
- [x] 1.3 Make `LanePicker.pick` use the two-cloud share; add a seeded `lane_picker_test` checking the share at score 0 and at ramp end and that all three lanes are never filled
- [x] 1.4 Wire speed, spacing and share from the score in `FrightFlightGame.update`; verify `flutter test` passes

## 2. Moving clouds

- [x] 2.1 Add moving state (flag, phase, age) to `CloudSpec` and advance age in `CloudField.step`; only single-cloud groups at or above `movingCloudScore` may move, chosen with `movingCloudChance`; add tests that moving clouds stay within amplitude and inside their lane, do not appear early, and freeze when the field is not stepped
- [x] 2.2 Make `CloudComponent` follow the spec's current `centreY`; add a `collision_rules_test` case where a hit follows the cloud's current position

## 3. Soft ceiling

- [x] 3.1 Clamp the plane at the ceiling and zero upward speed in `PlaneBody.step`; remove the ceiling from `CollisionRules.hitsBounds`; rewrite the ceiling tests in `plane_body_test`, `collision_rules_test` and any flow test to expect no game over at the ceiling and game over at the ground

## 4. Living ready screen

- [x] 4.1 Hover the plane in the ready state (`hoverAmplitude`, `hoverPeriod`) and start the run from the current hover position; add a test that in ready the plane stays within the amplitude and that the first tap flaps from the current `y`
- [x] 4.2 Draw a pulsing "TAP TO FLY" prompt only in the ready state; add a test that the prompt is rendered/active only in ready

## 5. Fairness and docs

- [x] 5.1 Extend `lane_fit_and_simulation_test` to run the bot at `maxScrollSpeed`, `minSpawnSpacing`, maximum two-cloud share and moving clouds on, with the soft ceiling; if it fails, raise `minSpawnSpacing` until it passes on all seeds and record the value in `design.md`
- [x] 5.2 Update the "Game rules" section of `openspec/project.md` (ceiling no longer ends a run, ramp to score 60, moving clouds); verify by reading it
- [x] 5.3 Run `dart format`, `flutter analyze` and `flutter test`; verify all pass
- [ ] 5.4 Developer plays a release build and confirms the ramp feels moderate and fair, the ceiling feels right and the ready screen reads clearly
