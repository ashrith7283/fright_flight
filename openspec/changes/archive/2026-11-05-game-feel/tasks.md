# Tasks

## 1. Score pop

- [x] 1.1 Add the pop constants to `GameConfig` and the pop timer and scale to `ScoreHud`; add a test that the pop scale peaks at most at `scorePopScale` and returns to 1 within `scorePopDuration`, and restarts on a quick second point

## 2. Crash impact and fall

- [x] 2.1 Step the plane under gravity in game over until it rests on the ground, without collision checks; update `game_over_flow_test` to expect clouds frozen, the plane falling and then resting, and taps not flapping it
- [x] 2.2 Add the crash flash component and the camera shake with a reduced-motion skip, both reset on restart; add tests that the shake offset returns to zero after its duration, is absent with reduced motion, and that restart clears both

## 3. Near miss

- [x] 3.1 Add `CollisionRules.proximity` and a pure `NearMissTracker`; unit-test close pass, comfortable pass, one event per group, no event on crash, and clearing on reset
- [x] 3.2 Show a rising, fading "CLOSE!" label at the plane on each near-miss event; verify by test that an event adds the label and it is removed after `nearMissLabelDuration`

## 4. Integration

- [x] 4.1 Add a test that score and state transitions are identical with effects enabled and disabled for a fixed seeded run; run `dart format`, `flutter analyze` and `flutter test` and verify all pass
- [ ] 4.2 Developer plays a release build and confirms the pop, shake, flash, fall and near-miss label feel good and not distracting
