# visual-style Specification

## Purpose
Defines how the plane, clouds and background are presented so the game looks like an aeroplane flying through a sky, without changing gameplay geometry.

## Requirements

### Requirement: Plane looks like an aeroplane
The plane SHALL be drawn as a side-view aeroplane facing right, with at least a fuselage with nose, a wing, a tail fin and a cockpit window, within the plane's configured footprint.

#### Scenario: Plane is recognisable
- **WHEN** the plane is on screen in any game state where it is shown
- **THEN** it is drawn with fuselage, wing, tail and cockpit rather than a plain rectangle

#### Scenario: Plane tilts with vertical motion
- **WHEN** the plane is rising or falling during a run
- **THEN** it is tilted nose-up or nose-down in proportion to its vertical velocity, within a limited angle

#### Scenario: Propeller animates during a run
- **WHEN** a run is in progress
- **THEN** the propeller appears to spin

### Requirement: Clouds look like clouds
Each obstacle cloud SHALL be drawn as a soft white puffy cloud made of overlapping rounded lobes with subtle shading, contained within the cloud's configured width and height.

#### Scenario: Cloud stays within its bounds
- **WHEN** a cloud is drawn
- **THEN** no part of it extends beyond its configured bounding box

#### Scenario: Cloud is not a plain ellipse
- **WHEN** a cloud is on screen
- **THEN** its outline is visibly lobed rather than a single flat ellipse

### Requirement: Background looks like a sky
The background SHALL show a vertical sky gradient, a sun, and a ground with horizon detail, and SHALL fill the whole viewport including letterbox areas.

#### Scenario: Sky gradient fills the screen
- **WHEN** the game is displayed at any aspect ratio
- **THEN** sky and ground colours extend to every screen edge with no bare bars

#### Scenario: Background scrolls during a run
- **WHEN** a run is in progress
- **THEN** hills and ground detail drift left more slowly than the obstacle clouds

#### Scenario: Background is still when not running
- **WHEN** the game is in the ready, paused or game-over state
- **THEN** the background does not scroll

### Requirement: Visuals do not affect gameplay
Visual styling SHALL NOT change hitboxes, collision results, lane positions, speeds, spawn spacing or scoring.

#### Scenario: Collisions unchanged
- **WHEN** the plane overlaps a cloud's collision ellipse or touches the ceiling or ground line
- **THEN** the result is the same as before the visual change, regardless of how the art is drawn

#### Scenario: Only obstacles are clouds
- **WHEN** the game is displayed
- **THEN** every cloud on screen is an obstacle cloud; the background contains no clouds

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
