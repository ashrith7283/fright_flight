# Spec Delta

## MODIFIED Requirements

### Requirement: Game starts in the ready state
When the app launches, the main menu SHALL be shown first. When the player chooses Play, or restarts after a run, the game SHALL be in the ready state, showing the plane at its starting position over the sky and ground, with no clouds. The first tap in the ready state SHALL start the run.

#### Scenario: Launch
- **WHEN** the app launches
- **THEN** the main menu is shown and no run is in progress

#### Scenario: Play enters ready
- **WHEN** the player chooses Play on the main menu
- **THEN** the game is in the ready state and nothing moves

#### Scenario: First tap starts the run
- **WHEN** the game is in the ready state and the player taps
- **THEN** the game enters the playing state, the plane receives a flap impulse and cloud spawning begins

## ADDED Requirements

### Requirement: Paused run is frozen
A run in the playing state MAY be paused. While paused, the plane, clouds, score and restart timer SHALL NOT change, collisions SHALL NOT be evaluated and taps SHALL NOT flap the plane. Resuming SHALL restore the playing state without any jump in positions.

#### Scenario: Time does not pass while paused
- **WHEN** the game is paused for any length of time and then resumed
- **THEN** the plane and clouds continue from the same positions, with no extra movement for the paused time

#### Scenario: No crash while paused
- **WHEN** the game is paused with the plane close to a cloud
- **THEN** no collision occurs until the run is resumed and play moves the plane
