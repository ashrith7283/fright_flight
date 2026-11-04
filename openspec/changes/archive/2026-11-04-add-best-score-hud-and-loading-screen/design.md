# Design

## Context

`ScoreHud` is a Flame component that renders from `ScoreKeeper` (`score`, `highScore`) and `RunState`; text comes from `ScoreText`. The game's `onLoad` already awaits the saved score, the mute setting and the audio preload. `GameWidget` in `lib/main.dart` is built with overlays and a sky `backgroundBuilder`; Flame's `GameWidget` also accepts a `loadingBuilder` shown while `onLoad` runs. The Android launch drawable is the Flutter template default. See proposal.md for motivation and assumptions.

## Goals / Non-Goals

**Goals:** best score visible in play; a polished, non-flashing start-up.

**Non-Goals:** progress percentages, native splash plugins, redesigning the HUD or game-over screen.

## Decisions

- **Best score line in `ScoreHud`**: add `ScoreText.best(score, highScore)` returning `'Best: ${max(score, highScore)}'`, drawn smaller under the live score in playing and paused, and alone in ready. `max` makes the value rise live without touching storage (storage still written only in `finishRun`). It lives in `ScoreText` so it is unit-testable like the other text. Rejected: updating `ScoreKeeper.highScore` mid-run (would change when "new best" is detected and violate "no writes during play" intent).
- **Pause button overlap**: the pause button is top-right; both texts are top-left, so no overlap.
- **Loading screen as a Flutter widget** (`LoadingScreen`) passed to `GameWidget.loadingBuilder`: sky gradient matching the game, the title, a simple plane icon drawn with `CustomPaint`/existing colours or an `Icon(Icons.flight)` rotated, a `CircularProgressIndicator` and a "Loading..." label. Keeps it independent of Flame, so it can show before the game is ready. Alternative: Flame component in the game (cannot show before `onLoad` finishes, which is the time it is needed).
- **Minimum time**: in `onLoad`, run the real loading and a `Future.delayed(minLoadTime)` together with `Future.wait`, so the loading screen lasts `max(real load, minimum)`. `minLoadTime` is a constructor parameter defaulting to `GameConfig.loadingMinDuration` (1.2 s) so tests pass `Duration.zero`.
- **Failure safety**: existing loads already swallow errors; the delay future cannot fail; wrap the combined wait in try/catch as a final guard so the game never stays in loading.
- **Cold start only**: `onLoad` runs once per game instance, so returning to the menu never shows it.
- **Native launch screen**: set the Android `launch_background.xml` (both `drawable` and `drawable-v21`) to the sky colour, and the night `styles.xml` accordingly if it overrides the background. iOS launch screen background is set to the same colour if an iOS target exists with the default storyboard.
- **Constants** (`loadingMinDuration`, best-text font size) go in `GameConfig`.

## Risks / Trade-offs

- 1.2 s minimum adds a fixed delay to every cold start; kept short and configurable.
- Android 12+ shows its own system splash (icon on a colour) before the app; its colour is controlled by theme attributes, so the "no flash" guarantee on those devices depends on setting the splash background colour too.
- The gradient on the loading screen must visually match the in-game sky to avoid a jump; shared colour constants from `GameConfig` are used.
