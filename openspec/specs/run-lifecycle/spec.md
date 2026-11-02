# run-lifecycle Specification

## Purpose

Defines the lifecycle of a single run (ready, playing, game over), what ends a run, and the platform presentation of the game on Android phones.

## Requirements

### Requirement: Game starts in the ready state
When the game launches, it SHALL be in the ready state, showing the plane at its starting position over the sky and ground, with no clouds. The first tap SHALL start the run.

#### Scenario: Launch
- **WHEN** the app launches
- **THEN** the game is in the ready state and nothing moves

#### Scenario: First tap starts the run
- **WHEN** the game is in the ready state and the player taps
- **THEN** the game enters the playing state, the plane receives a flap impulse and cloud spawning begins

### Requirement: Game-over state freezes play
In the game-over state, the plane and all clouds SHALL stop moving, further flap taps SHALL NOT move the plane, and the score SHALL NOT change. The game-over state SHALL show the final score, the high score and, when the high score was beaten in that run, a new best indication.

#### Scenario: Scene frozen after crash
- **WHEN** the game is in the game-over state
- **THEN** the plane and clouds remain at their positions at the moment of collision

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
During the playing state, any contact between the plane and a cloud, the ground or the ceiling SHALL immediately end the run and move the game to the game-over state. Contact with a cloud is overlap with the cloud's elliptical shape, not its bounding box.

#### Scenario: Plane hits a cloud
- **WHEN** the plane's bounds overlap the elliptical shape of a cloud
- **THEN** the game enters the game-over state in that frame

#### Scenario: Plane hits the ground or ceiling
- **WHEN** the plane touches the ground or the ceiling
- **THEN** the game enters the game-over state in that frame

#### Scenario: Plane passes over or under a cloud
- **WHEN** the plane is horizontally level with a cloud and fully above or fully below its ellipse
- **THEN** no collision occurs

#### Scenario: Plane clips only the bounding-box corner
- **WHEN** the plane overlaps the corner of a cloud's bounding box but not the ellipse itself
- **THEN** no collision occurs
