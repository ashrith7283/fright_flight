# Proposal

## Why

This is roadmap item 5, `art-audio-polish`. Sound effects, plane tilt and a basic parallax sky are done, but haptics, the difficulty curve and richer sky art are still missing, and the menus, pause and game-over screens still use plain default Material widgets that look dated next to the game scene.

## What Changes

- **UI modernisation (glassy cards on sky)**: a shared glass look (translucent rounded panels with blur, soft shadows, pill buttons with icons) applied to the main menu, pause menu, pause button, mute and vibration toggles, game-over screen and loading screen.
- **Game-over redesign**: replace the Flame-drawn game-over text plus separate buttons with one animated glass panel showing score, best, a "new best" badge, and Restart and Menu buttons.
- **Haptics**: short vibration on flap, score and crash, with an on/off toggle saved between launches.
- **Difficulty ramp**: scroll speed rises gently with the score and is capped; spawn spacing stays fixed so groups stay fair.
- **Sky art**: extra parallax layers (far mountains, drifting haze) and a sky that shifts from day through sunset to dusk as the score rises, with the sun lowering.
- Gameplay geometry, hitboxes, lanes and scoring rules do not change.

## Capabilities

### New Capabilities
- `haptics`: vibration feedback and its persisted setting.
- `ui-style`: the shared glass look and consistent menu, button and panel behaviour.

### Modified Capabilities
- `cloud-obstacles`: scroll speed is no longer constant; it ramps with score up to a cap.
- `visual-style`: more parallax layers and a score-driven sky progression.
- `screens-and-navigation`: game-over actions are part of the new game-over panel.
- `scoring`: game-over score display is a panel rather than plain text.

## Impact

- New `lib/ui/glass_panel.dart`, `lib/ui/pill_button.dart`, `lib/ui/game_over_panel.dart`, `lib/ui/settings_toggles.dart`; restyled `main_menu.dart`, `pause_menu.dart`, `pause_button.dart`, `mute_button.dart`, `loading_screen.dart`; `game_over_actions.dart` replaced.
- New `lib/services/haptics_service.dart`; `StorageService` gains haptics read/write.
- New `lib/game/logic/difficulty_curve.dart`, `lib/game/logic/sky_palette.dart`; changes to `cloud_field.dart`, `smoke_puffs.dart`, `background_component.dart`, `score_hud.dart` (drops game-over text), `fright_flight_game.dart`.
- `GameConfig` gains difficulty, haptics and sky constants.
- No new dependencies (uses Flutter's `HapticFeedback` and `BackdropFilter`).
- Out of scope: custom fonts, new audio assets, settings screen, ads, release work, tablet layouts, iOS.

## Assumptions

- The ramp changes speed only; spawn spacing stays fixed so the existing "fixed spacing" requirement still holds.
- Speed ramps by a fixed amount per point up to a cap; the exact numbers are tuning values in `GameConfig`, set during implementation and checked by playing.
- The vibration toggle is separate from the sound mute and defaults to on.
- The in-run score text stays plain text with a subtle shadow; only game-over and menus become panels.
