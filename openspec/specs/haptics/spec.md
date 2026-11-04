# haptics Specification

## Purpose
Defines the vibration feedback for key game events and the player's on/off setting for it.

## Requirements

### Requirement: Haptic feedback for key events
The game SHALL give a short vibration for each of: a flap, a point scored, and a crash. The crash vibration SHALL be stronger than the flap and score vibrations. Each event SHALL cause at most one vibration.

#### Scenario: Flap vibration
- **WHEN** the player taps during a run and the flap is accepted
- **THEN** one light vibration occurs

#### Scenario: Score vibration
- **WHEN** the plane passes a cloud group and the score increases
- **THEN** one vibration occurs for that increase

#### Scenario: Crash vibration
- **WHEN** the plane collides with a cloud, the ground or the ceiling
- **THEN** one strong vibration occurs

#### Scenario: Ignored taps do not vibrate
- **WHEN** a tap is ignored (menu, paused, or game over)
- **THEN** no vibration occurs

### Requirement: Vibration toggle
The main menu and the pause menu SHALL each show a vibration button that turns haptics on or off. While off, no vibration SHALL occur. The setting SHALL persist between launches, default to on, and be independent of the sound mute.

#### Scenario: Turning vibration off
- **WHEN** the player turns vibration off and then flaps, scores or crashes
- **THEN** no vibration occurs

#### Scenario: Setting persists
- **WHEN** the player turns vibration off and relaunches the app
- **THEN** vibration is still off and the button shows the off state

#### Scenario: Independent of sound
- **WHEN** the player mutes the sound
- **THEN** vibration stays as the player set it, and vice versa

#### Scenario: Both menus agree
- **WHEN** the vibration setting changes in one menu
- **THEN** the other menu shows the same state when next displayed

### Requirement: Haptics never disrupt play
A failure to vibrate (no vibration hardware, platform error) or to read or write the setting SHALL NOT interrupt gameplay or crash the app.

#### Scenario: No vibration hardware
- **WHEN** the device cannot vibrate
- **THEN** the game plays normally with no vibration

#### Scenario: Storage failure
- **WHEN** reading the saved setting fails
- **THEN** vibration defaults to on, and a failed write keeps the in-memory setting for the session
