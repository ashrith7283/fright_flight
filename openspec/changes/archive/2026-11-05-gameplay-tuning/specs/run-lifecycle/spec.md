# Spec Delta

## MODIFIED Requirements

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
