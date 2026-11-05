# plane-control Specification

## Purpose

Defines how the player's plane moves: it falls under gravity and the player lifts it with a single tap, within the vertical bounds of the play area.

## Requirements

### Requirement: Plane falls under gravity
While a run is in progress, the plane SHALL accelerate downward at the configured gravity value, and its vertical speed SHALL NOT exceed the configured maximum fall speed. In the ready state the plane SHALL NOT be affected by gravity; it SHALL hover around its starting position, bobbing smoothly by at most the configured hover amplitude.

#### Scenario: Plane falls with no input
- **WHEN** a run is in progress and the player does not tap
- **THEN** the plane moves downward with increasing speed until it reaches the maximum fall speed

#### Scenario: Plane does not move before the run starts
- **WHEN** the game is in the ready state
- **THEN** the plane is unaffected by gravity and only bobs around its starting position, never further than the hover amplitude

#### Scenario: Run starts from the hover position
- **WHEN** the player taps in the ready state
- **THEN** the run starts from the plane's current hover position with no visible jump

### Requirement: Tap flaps the plane
A tap anywhere on the screen during a run SHALL set the plane's vertical velocity to the configured flap impulse, directed upward, replacing any current vertical velocity.

#### Scenario: Tap while falling
- **WHEN** the plane is falling and the player taps
- **THEN** the plane immediately moves upward at the flap impulse speed, then decelerates under gravity

#### Scenario: Repeated taps do not stack
- **WHEN** the player taps several times in quick succession
- **THEN** the upward speed after each tap equals the flap impulse and never exceeds it

### Requirement: Plane is bounded vertically
The play area SHALL have a ceiling at the top edge of the screen and a ground at a configured height above the bottom edge. Touching the ground SHALL count as a collision. Touching the ceiling SHALL NOT be a collision: the plane SHALL be held at the ceiling and its upward speed set to zero, so it then falls under gravity.

#### Scenario: Plane reaches the ceiling
- **WHEN** the top of the plane's hitbox reaches the top edge of the play area while moving up
- **THEN** no collision is reported, the plane stays at the ceiling and its upward speed becomes zero

#### Scenario: Flapping at the ceiling
- **WHEN** the player keeps tapping while the plane is at the ceiling
- **THEN** the plane does not pass above the ceiling and the run continues

#### Scenario: Plane reaches the ground
- **WHEN** the bottom of the plane reaches the ground line
- **THEN** a collision is reported
