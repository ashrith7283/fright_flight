# Design

## Context

Game logic is Flame-free (`RunController`, `CloudField`, `ScoreKeeper`), rendering is Flame components (`BackgroundComponent`, `PlaneComponent`, `SmokeTrail`, `ScoreHud`), and menus are Flutter overlays wired in `lib/main.dart` using plain Material widgets. Game-over currently shows text drawn by `ScoreHud` plus a separate delayed `GameOverActions` overlay. Scroll speed is the constant `GameConfig.scrollSpeed`, read by `CloudField`, `SmokePuffs` and the background. Services (`AudioService`, `StorageService`) are interfaces with fakes for tests. See proposal.md for scope and assumptions.

## Goals / Non-Goals

**Goals:** a consistent modern UI; haptics; a capped difficulty ramp; richer sky art; all new logic unit-testable without Flame.

**Non-Goals:** custom fonts, new audio assets, a settings screen, ads, release work.

## Decisions

### Difficulty ramp
- `DifficultyCurve.speedFor(score)` = `min(baseSpeed + speedPerPoint * score, maxSpeed)`, plain Dart, in `lib/game/logic/difficulty_curve.dart`. `GameConfig`: `scrollSpeed` stays as the base; add `scrollSpeedPerPoint` and `maxScrollSpeed`.
- `CloudField.step(dt, speed)` takes the speed for the step; `_scrolled` advances by `speed * dt`, so spawn spacing in distance stays fixed (the existing spacing requirement still holds) and groups arrive more often in time as speed rises. `SmokePuffs` takes the same speed. The game passes `DifficultyCurve.speedFor(_score.score)` each update.
- Fairness check: the vertical reach of the plane per second is fixed, so the cap is chosen so that adjacent groups at the cap are still passable; confirmed by extending the existing lane-fit simulation test to run at the cap.
- Alternative rejected: also shrinking spacing (harder to guarantee fairness; the project allows it, but speed-only is simpler and testable).

### Sky progression and parallax
- `SkyPalette.at(score)` (pure, `lib/game/logic/sky_palette.dart`) returns top colour, bottom colour and a sun height fraction by lerping between day, sunset and dusk keyframes over configured score stops (`skySunsetScore`, `skyDuskScore`). `BackgroundComponent` eases a displayed value towards the target each frame (exponential smoothing), so score steps and restarts never jump. It reads the score through a callback like `isRunning`.
- New layers in `BackgroundComponent`: far mountains (slowest, lighter, tinted by the sky bottom colour for depth), a haze band of a few soft ellipses drifting, then the existing hills. Each has its own parallax factor and repeat distance in `GameConfig`. All advance only while running. Paths are built once per repeat period and cached where possible.
- Readability at dusk: dusk top colour stays mid-dark blue, not black; cloud white and plane red keep contrast; the score text gets a subtle shadow.

### Haptics
- `HapticsService` interface (`flap()`, `score()`, `crash()`, `setEnabled(bool)`) with `FlutterHapticsService` calling `HapticFeedback.lightImpact` (flap, score; score uses `selectionClick`) and `heavyImpact` (crash), swallowing errors, and a `NoopHapticsService`/recording fake for tests. Wired in `FrightFlightGame` at exactly the places audio is called.
- Setting: `ValueNotifier<bool> vibration` on the game next to `muted`, loaded in `onLoad`, persisted via new `StorageService.readHaptics/writeHaptics` (failures degrade to on).
- Android needs no extra permission for `HapticFeedback` (it uses the view's haptic feedback); if a device ignores it, nothing happens, which is acceptable.

### UI style (glass on sky)
- Shared building blocks in `lib/ui/`: `GlassPanel` (`ClipRRect` + `BackdropFilter` blur + translucent white fill, thin border, soft shadow, fade+scale-in via `TweenAnimationBuilder`), `PillButton` (primary filled with accent red, secondary translucent outline; icon + label; min 48 dp height), `SettingsToggles` (round glass icon buttons for sound and vibration bound to the notifiers, with tooltips/semantics). Colours, radii and animation time live in `GameConfig`/a small `UiTheme` constants file.
- Screens: `MainMenu` (title block over the scene, best-score chip, primary Play, toggles top-right), `PauseMenu` (glass card: Resume primary, Menu secondary, toggles), `PauseButton` (round glass), `LoadingScreen` restyled. Layouts use `SafeArea`, `FittedBox`/constrained heights for short landscape screens.
- `BackdropFilter` cost: only a few small panels, only on menu screens, not during play; acceptable on low-end phones. If a device struggles, blur sigma is a constant that can be set to 0 (translucent fill only).

### Game-over panel
- New `GameOverPanel` overlay shown the moment the state becomes `gameOver` (replaces both the Flame text and `GameOverActions`): "GAME OVER", score, best, a "NEW BEST" badge when earned, Restart (primary) and Menu. `FrightFlightGame` exposes `score`, `highScore`, `newBest` and a `ValueNotifier<bool> restartReady` updated in `update` from `RunController.canRestart`; buttons are disabled while it is false. Tap-to-restart anywhere stays as it is (already gated by the same delay).
- `ScoreHud` drops its game-over branch (and `ScoreText.gameOver` is kept only if still used by the panel; otherwise removed, with its test moved to the panel's text helper).
- `_syncOverlays` maps `gameOver` to the panel overlay instead of the delayed actions overlay.

## Risks / Trade-offs

- Speed ramp tuning needs play-testing; numbers start conservative and are constants. After play-testing felt harder than the original, they were softened to base 220, +1 per point, cap 260. The same feedback reduced the plane's maximum tilt (0.45 to 0.22 rad) and eased it so quick taps do not snap the nose, and the sky gradient shader is now cached instead of rebuilt every frame.
- Several modified specs (cloud-obstacles, screens-and-navigation, scoring) change at once; each is a narrow edit and the tests that covered the old behaviour are updated alongside.
- Blur panels on low-end devices: mitigated by the blur constant and by using blur only on menu screens.
- Haptics strength varies by device; the three event levels (light, selection, heavy) are the conservative common denominator.
