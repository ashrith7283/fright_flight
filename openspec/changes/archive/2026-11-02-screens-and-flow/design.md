# Design

## Context

`FrightFlightGame` (Flame) owns `RunController` with `RunState { ready, playing, gameOver }`, `ScoreKeeper` and the cloud/plane state. `main.dart` runs a bare `GameWidget`; there is no `lib/ui/`. `ScoreHud` switches exhaustively on `RunState`. A tap anywhere is the only input, handled by `TapCallbacks` on the game. Storage faults are already absorbed in `ScoreKeeper`.

## Goals / Non-Goals

**Goals:**
- Menu, pause and game-over buttons as ordinary Flutter widgets over the game.
- State transitions (including back-button and pause rules) in plain Dart, unit tested without Flame.
- Pausing cannot be defeated by a stray tap or by time passing.

**Non-Goals:**
- Routing packages, Riverpod or `ChangeNotifier` app state. The game object is the single source of truth and `project.md` says not to over-engineer.
- Settings, sound toggles, animations, resume countdown.

## Decisions

### Flame overlays, not Navigator routes
`GameWidget(overlayBuilderMap: ...)` with named overlays: `mainMenu`, `pauseButton`, `pauseMenu`, `gameOverActions`. The game adds and removes them via `overlays.add/remove`. The game keeps running underneath (needed so the sky and plane are visible behind the menu and so state is not rebuilt), and Flutter widgets draw the buttons, which gives real tap targets and hit testing instead of hand-rolled Flame buttons. Overlay builders run each time an overlay is added, so the menu reads the current high score when shown without extra listeners.

Alternatives: `Navigator` with separate routes and the game in one of them (recreates or re-parents the game, complicates preserving the scene for pause); Flame button components (more code, worse accessibility, nothing to reuse in later settings and ads screens).

### Extend `RunState` with `menu` and `paused`
`RunState { menu, ready, playing, paused, gameOver }`. The app starts in `menu`. `RunController` gains `play()` (menu to ready), `pause()` (playing to paused), `resume()` (paused to playing), `toMenu()` (any state to menu, invoking `onReset`) and `restart()` (game over to ready after the delay, shared with tap restart). `onTap` ignores `menu` and `paused`. `update` only advances the restart timer in `gameOver`, and the game's `update` already steps the world only in `playing`, so a paused run is frozen by construction with no extra clock handling. `ScoreHud` shows nothing in `menu`, and for `paused` it keeps drawing the live score. The enum is the single place that decides which overlays show: the game maps state to overlay set in one `_syncOverlays()` call after every transition, so overlays cannot drift from state.

### Pause is a state, not `pauseEngine()`
Pausing sets `RunState.paused` rather than calling `pauseEngine()`. The scene stays rendered, the frame step keeps being clamped by `maxFrameDelta`, and a long pause never produces a large `dt` on resume, so there is no position jump (spec: no jump). Collisions only run inside the `playing` branch, so none occur while paused.

### Automatic pause on backgrounding
`FrightFlightGame` overrides `lifecycleStateChange(AppLifecycleState)` and calls `pause()` when the app is not `resumed` and the state is `playing`. It never resumes by itself. Verify on a device that Flame's own engine pause on background does not conflict (Flame already stops updates in the background; our state change only decides which overlay is shown on return).

### Back button via `PopScope`
Wrap `GameWidget` in `PopScope(canPop: false, onPopInvokedWithResult: ...)`. The decision is a pure function `BackAction backActionFor(RunState)` returning `pause | resume | toMenu | exitApp`; the widget executes it, calling `SystemNavigator.pop()` for `exitApp`. This keeps the rule table unit-testable and the Android specifics in one line.

### Abandoning a run never saves
`toMenu()` calls the existing `_reset` (score reset, scene cleared) and never calls `ScoreKeeper.finishRun`. A game-over run was already finished and saved on the crash frame, so Menu from game over shows the saved high score. Only the crash path saves, as today.

### Game-over buttons appear after the restart delay
`gameOverActions` is added when `RunController` reports the delay has elapsed (a `bool get canRestart`). This keeps buttons and the tap-restart rule on the same gate and prevents an instant accidental restart by tapping where the button will appear. The Flame score text is unchanged; the overlay sits below it using a `GameConfig` anchor so they do not overlap.

### Layout
Overlays use Flutter layout in logical pixels (not world units) and respect `SafeArea` for notches. Colours reuse `GameConfig` colour constants where one exists. Only values the game logic needs (none expected beyond the game-over actions' vertical anchor) go in `GameConfig`; widget padding and font sizes stay in the widgets.

## Risks / Trade-offs

- [Overlay taps leaking to the game as flaps] → Overlay widgets sit above the game in the widget stack and consume taps; pause button presses are covered by a widget test and an emulator check. `onTap` also ignores `menu` and `paused` as a second guard.
- [Back button during the restart delay] → `backActionFor(gameOver)` is `toMenu` regardless of the delay; acceptable, since leaving cannot cause an accidental restart.
- [`PopScope` API differences across Flutter versions] → pin to the version in `pubspec.yaml` (`onPopInvokedWithResult`); verify with `flutter analyze`.
- [Lifecycle callback timing differs between devices] → covered by the manual checklist, not by tests.
