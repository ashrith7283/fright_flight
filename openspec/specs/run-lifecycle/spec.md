# run-lifecycle Specification

## Purpose

Defines the lifecycle of a single run (menu, ready, playing, paused, game over), what ends a run, and the platform presentation of the game on Android phones.

## Requirements

### Requirement: Game starts in the ready state
When the app launches, the main menu SHALL be shown first. When the player chooses Play, or restarts after a run, the game SHALL be in the ready state, showing the plane hovering near its starting position over the sky and ground, with no clouds, and a "TAP TO FLY" prompt. The first tap in the ready state SHALL start the run and hide the prompt.

#### Scenario: Launch
- **WHEN** the app launches
- **THEN** the main menu is shown and no run is in progress

#### Scenario: Play enters ready
- **WHEN** the player chooses Play on the main menu
- **THEN** the game is in the ready state, the plane hovers, no clouds or background layers scroll, and the tap prompt is shown

#### Scenario: First tap starts the run
- **WHEN** the game is in the ready state and the player taps
- **THEN** the game enters the playing state, the plane receives a flap impulse, cloud spawning begins and the tap prompt disappears

#### Scenario: Prompt only in ready
- **WHEN** the game is in the menu, playing, paused or game-over state
- **THEN** the tap prompt is not shown

### Requirement: Game-over state freezes play
In the game-over state, all clouds SHALL stop moving, further flap taps SHALL NOT move the plane, and the score SHALL NOT change. The plane SHALL fall nose-down under gravity from where it crashed until it rests on the ground, without collisions being evaluated. The game-over state SHALL show the final score, the high score and, when the high score was beaten in that run, a new best indication.

#### Scenario: Scene frozen after crash
- **WHEN** the game is in the game-over state
- **THEN** the clouds remain at their positions at the moment of collision, and the plane falls until it rests on the ground and then stays still

#### Scenario: Taps do not move the falling plane
- **WHEN** the player taps during game over before the restart delay has elapsed
- **THEN** the plane keeps falling and receives no flap

#### Scenario: Score and high score shown
- **WHEN** the game enters the game-over state
- **THEN** the final score and the high score are displayed

#### Scenario: New best shown
- **WHEN** the game enters the game-over state with a final score above the previous high score
- **THEN** a new best indication is displayed together with the score and high score

### Requirement: Tap restarts after game over
A tap in the game-over state SHALL reset the game to the ready state, with the plane at its starting position, all clouds removed and the score reset to 0. A short, configured delay after the crash SHALL pass before taps are accepted, to prevent an accidental instant restart.

#### Scenario: Restart after delay
- **WHEN** the game is in the game-over state, the restart delay has elapsed, and the player taps
- **THEN** the game returns to the ready state with a fresh scene and a score of 0

#### Scenario: Tap during restart delay
- **WHEN** the player taps before the restart delay has elapsed
- **THEN** the tap is ignored and the game stays in the game-over state

#### Scenario: Game-over text cleared on restart
- **WHEN** the game returns to the ready state after a restart
- **THEN** the game-over score text is no longer displayed

### Requirement: Android landscape presentation
The game SHALL run on Android phones in landscape orientation only, in either landscape direction, and SHALL scale the play area to the screen so that gameplay distances use the same logical units on every phone size.

#### Scenario: Launch orientation
- **WHEN** the app launches on a phone held in any orientation
- **THEN** the game is shown in landscape

#### Scenario: Device rotated
- **WHEN** the player holds the device upright in portrait
- **THEN** the game stays in landscape

#### Scenario: Landscape flipped
- **WHEN** the player turns the device from one landscape direction to the other
- **THEN** the game follows, remains in landscape and the run is not interrupted

#### Scenario: Different screen sizes
- **WHEN** the game runs on phones with different screen sizes or aspect ratios
- **THEN** the plane, cloud size, lanes and spacing look and behave the same relative to the visible play area

### Requirement: Collision with cloud, ground or ceiling ends the run
During the playing state, any contact between the plane and a cloud or the ground SHALL immediately end the run and move the game to the game-over state. Contact with a cloud is overlap with the cloud's elliptical shape at its current position, not its bounding box. Contact with the ceiling SHALL NOT end the run.

#### Scenario: Plane hits a cloud
- **WHEN** the plane's bounds overlap the elliptical shape of a cloud
- **THEN** the game enters the game-over state in that frame

#### Scenario: Plane hits the ground or ceiling
- **WHEN** the plane touches the ground, or touches the ceiling
- **THEN** touching the ground ends the run in that frame, while touching the ceiling does not end the run and the plane is held below the ceiling

#### Scenario: Plane passes over or under a cloud
- **WHEN** the plane is horizontally level with a cloud and fully above or fully below its ellipse
- **THEN** no collision occurs

#### Scenario: Plane clips only the bounding-box corner
- **WHEN** the plane overlaps the corner of a cloud's bounding box but not the ellipse itself
- **THEN** no collision occurs

### Requirement: Paused run is frozen
A run in the playing state MAY be paused. While paused, the plane, clouds, score and restart timer SHALL NOT change, collisions SHALL NOT be evaluated and taps SHALL NOT flap the plane. Resuming SHALL restore the playing state without any jump in positions.

#### Scenario: Time does not pass while paused
- **WHEN** the game is paused for any length of time and then resumed
- **THEN** the plane and clouds continue from the same positions, with no extra movement for the paused time

#### Scenario: No crash while paused
- **WHEN** the game is paused with the plane close to a cloud
- **THEN** no collision occurs until the run is resumed and play moves the plane
