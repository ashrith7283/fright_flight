# Proposal

## Why

The game boots straight into the ready state with no menu, no way to pause and no way to leave a run. Roadmap item 3 (`screens-and-flow`) adds the screens and navigation that make it a complete app, and the later release and ads changes need a menu screen to hang on to.

## What Changes

- New main menu shown at launch: game title, a Play button and the persisted high score. Play enters the ready state.
- Pause: a pause button visible only while playing. Pausing freezes the run; a pause overlay offers Resume and Menu. Resuming is by button only, so a stray tap cannot flap the plane. The app going to the background while playing pauses automatically.
- Game over: alongside the existing score text, Restart and Menu buttons. Tap-to-restart after the restart delay keeps working.
- Android back button: while playing, pauses; while paused, resumes; on game over or in ready, goes to the menu; on the menu, exits the app.
- Menu navigation from pause or game over discards the current run without saving a score (a game-over run has already been saved by `ScoreKeeper`).
- Flutter widgets (via Flame overlays) draw the menu, pause button, pause overlay and game-over buttons. The Flame `ScoreHud` text is unchanged.
- New `GameConfig` values for the overlay layout where the game needs them (the rest is widget styling).

Out of scope: settings screen, sound or haptics toggles, reset-high-score UI, resume countdown, art and animations, ads, release config, tablet layouts. A settings screen stays out until there is a setting to put in it.

## Capabilities

### New Capabilities
- `screens-and-navigation`: the main menu, the pause button and pause overlay, the game-over buttons, back-button behaviour and automatic pause on backgrounding.

### Modified Capabilities
- `run-lifecycle`: the game launches into the main menu instead of directly into the ready state; a new paused condition freezes a run; the menu is reachable from pause and game over. Ready, playing, game-over, collision and restart-by-tap behaviour are otherwise unchanged.

## Impact

- New: `lib/ui/` (main menu, pause button, pause overlay, game-over buttons), a small plain-Dart navigation/back-button logic unit with tests, and widget tests for the menu and game-over flows (per `project.md` testing section).
- Changed: `lib/main.dart` (overlay map, initial overlay), `FrightFlightGame` (pause, resume, go-to-menu, lifecycle hook), `RunController`/`RunState` (menu and paused handling), `GameConfig`.
- No new dependencies. Android only.
