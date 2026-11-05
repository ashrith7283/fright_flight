# Spec Delta

## MODIFIED Requirements

### Requirement: Layered parallax background
The background SHALL show at least one decorative layer beyond the hills, far mountains, scrolling at a speed slower than the hills, so that farther layers move more slowly than nearer ones. The background SHALL NOT contain oval or haze shapes. Layers SHALL scroll only while a run is in progress.

#### Scenario: Farther layers move slower
- **WHEN** a run is in progress
- **THEN** the mountains move more slowly than the hills, and the hills more slowly than the obstacle clouds

#### Scenario: Layers still when not running
- **WHEN** the game is in the ready, paused or game-over state
- **THEN** no background layer moves

#### Scenario: Layers wrap seamlessly
- **WHEN** a layer scrolls past its repeat distance
- **THEN** it wraps with no visible gap or jump

#### Scenario: No haze ovals
- **WHEN** the background is displayed in any game state
- **THEN** no translucent oval or haze shapes are drawn in the sky
