# sound Specification

## Purpose
Defines the game's sound effects, looping background music and the persisted mute setting, none of which may interfere with gameplay.

## Requirements

### Requirement: Sound effects for key events
The game SHALL play a distinct short sound for each of: a flap, a point scored, and a crash. Each sound SHALL play once per event.

#### Scenario: Flap sound
- **WHEN** the player taps during a run (including the tap that starts the run)
- **THEN** the flap sound plays once

#### Scenario: Score sound
- **WHEN** the plane passes a cloud group and the score increases
- **THEN** the score sound plays once for that increase

#### Scenario: Crash sound
- **WHEN** the plane collides with a cloud, the ground or the ceiling
- **THEN** the crash sound plays once and no flap or score sound plays for that frame

#### Scenario: No sound for ignored taps
- **WHEN** a tap is ignored (menu, paused, or game over before restart is allowed)
- **THEN** no flap sound plays

### Requirement: Background music
Looping background music SHALL start when the player taps Play, continue through the ready and playing states, pause while the game is paused or the app is not in the foreground, resume from where it paused, and stop on game over and when returning to the menu.

#### Scenario: Music starts on Play
- **WHEN** the player taps Play on the main menu
- **THEN** the music starts and loops until stopped

#### Scenario: Music pauses with the game
- **WHEN** the game is paused or the app goes to the background, and later resumes
- **THEN** the music pauses and then continues from the same position

#### Scenario: Music stops on game over
- **WHEN** the plane crashes
- **THEN** the music stops so the crash sound is heard clearly

#### Scenario: Music restarts on restart
- **WHEN** the player restarts after game over
- **THEN** the music starts again from the beginning

#### Scenario: Music stops on return to menu
- **WHEN** the player returns to the main menu
- **THEN** the music stops

### Requirement: Mute toggle
The main menu and the pause menu SHALL each show a speaker button that toggles mute. While muted, no sound effect or music SHALL be audible. The setting SHALL persist between launches and default to unmuted.

#### Scenario: Muting silences everything
- **WHEN** the player mutes and then plays, flaps, scores or crashes
- **THEN** no sound effect or music is audible

#### Scenario: Unmuting during a run
- **WHEN** the player unmutes from the pause menu and resumes
- **THEN** music is audible again and effects play for subsequent events

#### Scenario: Mute persists
- **WHEN** the player mutes and relaunches the app
- **THEN** the game starts muted and the speaker button shows the muted state

#### Scenario: Both menus agree
- **WHEN** the mute state changes in one menu
- **THEN** the other menu shows the same state when next displayed

### Requirement: Audio never disrupts play
A failure to load or play any sound, or to read or write the mute setting, SHALL NOT interrupt gameplay, change collisions or scoring, or crash the app. Sound SHALL NOT affect game timing.

#### Scenario: Audio unavailable
- **WHEN** an audio file cannot be loaded or played
- **THEN** the game continues normally without that sound

#### Scenario: Mute storage failure
- **WHEN** reading the saved mute setting fails
- **THEN** the game starts unmuted; a failed write keeps the in-memory setting for the session

### Requirement: Audio assets are licensed for use
Every bundled audio file SHALL be CC0 or otherwise free for commercial use without attribution, and its source and licence SHALL be recorded in the repository.

#### Scenario: Credits recorded
- **WHEN** the repository is inspected
- **THEN** each audio file has a listed source URL and licence
