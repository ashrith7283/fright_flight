# Tasks

## 1. Constants

- [x] 1.1 Add to `lib/core/game_config.dart`: `scrollSpeedPerPoint`, `maxScrollSpeed`; sky stops and palettes (day, sunset, dusk) and sun heights; mountain/haze parallax factors and repeat distances; panel blur, radius, animation time and accent colours

## 2. Difficulty ramp

- [x] 2.1 Add `lib/game/logic/difficulty_curve.dart` (`speedFor(score)`, capped)
- [x] 2.2 Make `CloudField.step` and `SmokePuffs.step` take the current speed; pass the curve value from `FrightFlightGame.update`; reset on new run
- [x] 2.3 Tests: curve values, cap, speed reset, spacing stays fixed in distance, and the lane-fit simulation still passes at the maximum speed

## 3. Sky art and parallax

- [x] 3.1 Add `lib/game/logic/sky_palette.dart` (`at(score)` colours and sun height by lerp) with unit tests (day at 0, between at sunset, dusk limit, small step per point)
- [x] 3.2 Make `BackgroundComponent` use the eased palette from a score callback, lower the sun, and reset to day on a new run
- [x] 3.3 Add far-mountain and haze layers with their own parallax speeds, wrapping seamlessly, moving only while running
- [x] 3.4 Give the in-run score and best text a subtle shadow for readability at dusk

## 4. Haptics

- [x] 4.1 Add `lib/services/haptics_service.dart` (interface, Flutter implementation that never throws, no-op for tests)
- [x] 4.2 Add `readHaptics`/`writeHaptics` to `StorageService`, its implementation and the fake
- [x] 4.3 Add the `vibration` notifier and toggle in `FrightFlightGame`, load it in `onLoad`, and call haptics on accepted flap, score and crash
- [x] 4.4 Tests with a recording fake: one vibration per event, none for ignored taps, none when off, setting persists, storage failure defaults to on

## 5. UI style

- [x] 5.1 Create `GlassPanel`, `PillButton` and `SettingsToggles` (sound and vibration) in `lib/ui/`, with fade and scale-in and 48 dp minimum targets
- [x] 5.2 Restyle `MainMenu`, `PauseMenu`, `PauseButton`, `MuteButton` and `LoadingScreen` using them
- [x] 5.3 Wire the vibration notifier and toggle through `lib/main.dart` to both menus

## 6. Game-over panel

- [x] 6.1 Expose score, high score, new-best and a `restartReady` notifier from `FrightFlightGame`
- [x] 6.2 Create `lib/ui/game_over_panel.dart` (score, best, new-best badge, Restart primary, Menu secondary, disabled until `restartReady`) and replace `GameOverActions` in the overlay map and `_syncOverlays`
- [x] 6.3 Remove the game-over branch from `ScoreHud` and move any still-needed text helpers; update tests
- [x] 6.4 Widget tests: panel shows at once, buttons disabled then enabled, Restart and Menu callbacks, new-best badge only when earned

## 7. Verification

- [x] 7.1 Widget tests for the restyled menus (toggles reflect state, buttons call callbacks, no overflow in a short landscape size such as 640x300)
- [x] 7.2 Run `dart format`, `flutter analyze` and `flutter test`
- [x] 7.3 Run the app and check: UI look and readability on a real phone, haptics feel, difficulty ramp at the cap is fair, sky shifts smoothly to dusk, parallax layers, game-over panel animation, performance of blurred panels
