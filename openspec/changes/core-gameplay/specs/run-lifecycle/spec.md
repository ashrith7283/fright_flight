# Spec Delta

## Purpose

Defines the lifecycle of a single run (ready, playing, game over), what ends a run, and the platform presentation of the game on Android phones.

## ADDED Requirements

### Requirement: Game starts in the ready state
When the game launches, it SHALL be in the ready state, showing the plane at its starting position over the sky and ground, with no clouds. The first tap SHALL start the run.

#### Scenario: Launch
- **WHEN** the app launches
- **THEN** the game is in the ready state and nothing moves

#### Scenario: First tap starts the run
- **WHEN** the game is in the ready state and the player taps
- **THEN** the game enters the playing state, the plane receives a flap impulse and cloud spawning begins

### Requirement: Collision ends the run
During the playing state, any contact between the plane and a cloud, the ground or the ceiling SHALL immediately end the run and move the game to the game-over state.

#### Scenario: Plane hits a cloud
- **WHEN** the plane's bounds overlap the bounds of a top or bottom cloud
- **THEN** the game enters the game-over state in that frame

#### Scenario: Plane hits the ground or ceiling
- **WHEN** the plane touches the ground or the ceiling
- **THEN** the game enters the game-over state in that frame

#### Scenario: Plane passes through the gap
- **WHEN** the plane is horizontally inside a cloud pair and fully within its gap
- **THEN** no collision occurs

### Requirement: Game-over state freezes play
In the game-over state, the plane and all clouds SHALL stop moving and further flap taps SHALL NOT move the plane.

#### Scenario: Scene frozen after crash
- **WHEN** the game is in the game-over state
- **THEN** the plane and clouds remain at their positions at the moment of collision

### Requirement: Tap restarts after game over
A tap in the game-over state SHALL reset the game to the ready state, with the plane at its starting position and all clouds removed. A short, configured delay after the crash SHALL pass before taps are accepted, to prevent an accidental instant restart.

#### Scenario: Restart after delay
- **WHEN** the game is in the game-over state, the restart delay has elapsed, and the player taps
- **THEN** the game returns to the ready state with a fresh scene

#### Scenario: Tap during restart delay
- **WHEN** the player taps before the restart delay has elapsed
- **THEN** the tap is ignored and the game stays in the game-over state

### Requirement: Android portrait presentation
The game SHALL run on Android phones in portrait orientation only, and SHALL scale the play area to the screen so that gameplay distances use the same logical units on every phone size.

#### Scenario: Device rotated
- **WHEN** the player rotates the device to landscape
- **THEN** the game stays in portrait

#### Scenario: Different screen sizes
- **WHEN** the game runs on phones with different screen sizes or aspect ratios
- **THEN** the plane, gap size and spacing look and behave the same relative to the visible play area
