# Proposal

## Why

The best score is only visible on the menu and at game over, so the player cannot see the target to beat while playing. And at launch the player sees a blank screen while the game loads its score, audio and assets.

## What Changes

- Show the best (highest) score in the game window during play, under the live score, so the player always sees the target.
- Show the best score in the ready and paused states too, so it is visible whenever the game scene is visible after launch.
- During a run the displayed best never falls below the current score (it rises live when the player passes it), while the stored high score is still written only at game over.
- Add a loading screen shown from app launch until the game has finished loading (saved score, mute setting, audio preload), then hand over to the main menu.
- The loading screen shows the game title, a plane graphic, a progress indicator and a "Loading..." label on the sky background, and stays visible for a short minimum time so it does not flash.
- Match the native Android launch screen to the sky colour so there is no white flash before the loading screen.

## Capabilities

### New Capabilities
- `loading-screen`: What the player sees from app launch until the main menu appears.

### Modified Capabilities
- `scoring`: "Score is shown during play" also covers showing the best score in the game window.

## Impact

- `lib/game/components/score_hud.dart`, `lib/game/logic/score_text.dart` (best line), tests in `test/score_text_test.dart`.
- `lib/main.dart` (loading builder), new `lib/ui/loading_screen.dart`, `lib/game/fright_flight_game.dart` (minimum load time), `lib/core/game_config.dart` (constants).
- `android/app/src/main/res/drawable*/launch_background.xml` (and iOS launch screen if present) colour.
- No new dependencies.
- Out of scope: native splash images/animation packages, loading progress percentages, changing the game-over screen, changing when the high score is saved.

## Assumptions

- "Highest score in the game window" means the in-game view while playing (and ready/paused), not a separate screen.
- Loading screen minimum display time is 1.2 seconds, and it appears only at cold start (not when returning to the menu).
