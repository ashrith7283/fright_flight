# Spec Delta

## Purpose

Defines how the player's plane moves: it falls under gravity and the player lifts it with a single tap, within the vertical bounds of the play area.

## ADDED Requirements

### Requirement: Plane falls under gravity
While a run is in progress, the plane SHALL accelerate downward at the configured gravity value, and its vertical speed SHALL NOT exceed the configured maximum fall speed.

#### Scenario: Plane falls with no input
- **WHEN** a run is in progress and the player does not tap
- **THEN** the plane moves downward with increasing speed until it reaches the maximum fall speed

#### Scenario: Plane does not move before the run starts
- **WHEN** the game is in the ready state
- **THEN** the plane stays at its starting position and is unaffected by gravity

### Requirement: Tap flaps the plane
A tap anywhere on the screen during a run SHALL set the plane's vertical velocity to the configured flap impulse, directed upward, replacing any current vertical velocity.

#### Scenario: Tap while falling
- **WHEN** the plane is falling and the player taps
- **THEN** the plane immediately moves upward at the flap impulse speed, then decelerates under gravity

#### Scenario: Repeated taps do not stack
- **WHEN** the player taps several times in quick succession
- **THEN** the upward speed after each tap equals the flap impulse and never exceeds it

### Requirement: Plane is bounded vertically
The play area SHALL have a ceiling at the top edge of the screen and a ground at a configured height above the bottom edge. Touching either SHALL count as a collision.

#### Scenario: Plane reaches the ceiling
- **WHEN** the top of the plane reaches the top edge of the play area
- **THEN** a collision is reported

#### Scenario: Plane reaches the ground
- **WHEN** the bottom of the plane reaches the ground line
- **THEN** a collision is reported
