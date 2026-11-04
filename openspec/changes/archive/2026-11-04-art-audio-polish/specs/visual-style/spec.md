# Spec Delta

## ADDED Requirements

### Requirement: Layered parallax background
The background SHALL show at least two additional decorative layers beyond the hills, far mountains and a drifting haze, each scrolling at its own speed slower than the hills, so that farther layers move more slowly than nearer ones. Layers SHALL scroll only while a run is in progress.

#### Scenario: Farther layers move slower
- **WHEN** a run is in progress
- **THEN** the mountains move more slowly than the hills, and the hills more slowly than the obstacle clouds

#### Scenario: Layers still when not running
- **WHEN** the game is in the ready, paused or game-over state
- **THEN** no background layer moves

#### Scenario: Layers wrap seamlessly
- **WHEN** a layer scrolls past its repeat distance
- **THEN** it wraps with no visible gap or jump

### Requirement: Sky progresses with the score
The sky colours and the sun position SHALL change gradually as the score rises, from day, through sunset, to dusk, then stay at dusk beyond a configured score. They SHALL return to day when a new run starts. Changes SHALL be smooth, with no sudden colour jump.

#### Scenario: Day at score zero
- **WHEN** a run starts
- **THEN** the sky is in its day palette with the sun high

#### Scenario: Sunset as the score rises
- **WHEN** the score reaches the configured sunset range
- **THEN** the sky colours are between the day and dusk palettes and the sun is lower than at day

#### Scenario: Dusk is the limit
- **WHEN** the score exceeds the configured dusk score
- **THEN** the sky stays at the dusk palette

#### Scenario: Smooth transition
- **WHEN** the score increases by one point
- **THEN** the sky colours change by a small amount and never jump to another palette

#### Scenario: Readability at dusk
- **WHEN** the sky is at its darkest
- **THEN** the plane, obstacle clouds and score text remain clearly visible

#### Scenario: Return to day on restart
- **WHEN** the player restarts or returns to the menu
- **THEN** the sky returns to the day palette
