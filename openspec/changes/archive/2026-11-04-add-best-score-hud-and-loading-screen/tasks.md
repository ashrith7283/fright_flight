# Tasks

## 1. Best score in the game window

- [x] 1.1 Add `ScoreText.best(score, highScore)` returning `Best: N` with N = max(score, highScore), and best-text font size constant in `GameConfig`
- [x] 1.2 Draw the best line in `lib/game/components/score_hud.dart` for the ready (alone), playing and paused (under the live score) states
- [x] 1.3 Update `test/score_text_test.dart` for the new text, including the best rising past the stored high score and the fresh-install 0

## 2. Loading screen

- [x] 2.1 Add `loadingMinDuration` to `lib/core/game_config.dart`
- [x] 2.2 Create `lib/ui/loading_screen.dart` (sky gradient, title, plane graphic, progress indicator, "Loading..." label)
- [x] 2.3 Add a `minLoadTime` parameter to `FrightFlightGame` and make `onLoad` take at least that long, with a try/catch guard so it always finishes
- [x] 2.4 Pass `LoadingScreen` as the `loadingBuilder` of the `GameWidget` in `lib/main.dart`
- [x] 2.5 Set the native launch screen background to the sky colour (Android `launch_background.xml` in `drawable` and `drawable-v21`, night styles, and the Android 12 splash colour); check the iOS launch screen

## 3. Tests and verification

- [x] 3.1 Add a widget test that the loading screen shows before load completes, is replaced by the menu afterwards, and that the minimum time is honoured (using a fake clock via `pump`)
- [x] 3.2 Run `dart format`, `flutter analyze` and `flutter test`
- [x] 3.3 Run the app and check: best score in ready/playing/paused, best rising past the old record, loading screen on cold start with no white flash, menu afterwards
