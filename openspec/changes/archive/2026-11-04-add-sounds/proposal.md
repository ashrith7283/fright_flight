# Proposal

## Why

The game is silent. Sound feedback for flapping, scoring and crashing, plus background music, makes play feel responsive and finished.

## What Changes

- Play a short sound on each flap (tap during a run), when a cloud group is passed (score point), and on crash/game over.
- Play looping background music from when the player taps Play, pausing when the game is paused or the app is backgrounded, and stopping on game over and when returning to the menu.
- Add a mute toggle (speaker icon) on the main menu and the pause menu; the choice mutes both effects and music and is saved between launches.
- Use free CC0-licensed audio files bundled as assets, with their sources and licences recorded in the repo.
- Audio failures (missing file, no audio device) never interrupt play.

## Capabilities

### New Capabilities
- `sound`: Sound effects, background music and the persisted mute setting.

### Modified Capabilities
<!-- None: screens-and-navigation is unchanged apart from a mute button added to existing menus, covered by the new spec. -->

## Impact

- New dependency: `flame_audio`.
- New assets: `assets/audio/` (flap, score, crash, music) plus `assets/audio/CREDITS.md`; `pubspec.yaml` asset declaration.
- New `lib/services/audio_service.dart` (interface + flame_audio implementation), mute persistence added to `lib/services/storage_service.dart`, event hooks in `lib/game/fright_flight_game.dart`, mute button in `lib/ui/main_menu.dart` and `lib/ui/pause_menu.dart`, wiring in `lib/main.dart`.
- Out of scope: separate music/effects volume sliders, haptics, per-platform audio tuning, in-game sound for UI button taps.

## Assumptions

- Music starts on the Play tap rather than at launch, so it also works on web where audio needs a user gesture.
- Specific clips are chosen during implementation from CC0 sources (e.g. Kenney, OpenGameArt); any clip with a licence other than CC0 is not used.
