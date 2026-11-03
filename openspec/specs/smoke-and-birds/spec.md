# smoke-and-birds Specification

## Purpose
Defines the cosmetic smoke trail behind the plane and the decorative birds in the background, neither of which affects gameplay.

## Requirements

### Requirement: Plane leaves a smoke trail
While a run is in progress, smoke puffs SHALL be emitted from the back of the plane at a steady rate. Each puff SHALL drift left with the scrolling world, grow and fade, and be removed once fully faded.

#### Scenario: Smoke appears behind the plane
- **WHEN** a run is in progress
- **THEN** puffs appear at the tail of the plane and trail off to the left, following the path the plane has flown

#### Scenario: Smoke fades out
- **WHEN** a puff reaches the end of its lifetime
- **THEN** it is fully transparent and no longer drawn or retained

#### Scenario: No new smoke when not running
- **WHEN** the game is in the menu, ready, paused or game-over state
- **THEN** no new puffs are emitted, and existing puffs do not advance while paused

#### Scenario: Smoke cleared on reset
- **WHEN** a run is reset (restart or return to menu)
- **THEN** all existing smoke puffs are removed

### Requirement: Birds fly in the background
The background SHALL show a small number of bird silhouettes flying across the sky with a flapping wing animation. Birds SHALL move slowly left, wrap around when they leave the screen, and stay within the upper sky area.

#### Scenario: Birds are visible and animated
- **WHEN** a run is in progress
- **THEN** a few small dark birds are visible in the sky, flying left with flapping wings

#### Scenario: Birds are still when not running
- **WHEN** the game is in the menu, ready, paused or game-over state
- **THEN** birds are visible but do not move or flap

#### Scenario: Birds wrap around
- **WHEN** a bird moves past the left edge of the screen
- **THEN** it re-enters from the right edge

#### Scenario: Birds are distinguishable from obstacles
- **WHEN** birds and obstacle clouds are on screen together
- **THEN** birds are much smaller than obstacle clouds and are dark rather than white

### Requirement: Effects do not affect gameplay
Smoke and birds SHALL NOT take part in collisions, scoring, cloud spawning or any other gameplay logic.

#### Scenario: Overlap has no effect
- **WHEN** the plane overlaps a bird or a smoke puff
- **THEN** no collision occurs and the score is unchanged
