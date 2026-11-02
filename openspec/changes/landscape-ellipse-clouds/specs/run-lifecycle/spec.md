# Spec Delta

## RENAMED Requirements

- FROM: `### Requirement: Android portrait presentation`
- TO: `### Requirement: Android landscape presentation`

## MODIFIED Requirements

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

## REMOVED Requirements

### Requirement: Collision ends the run
**Reason**: Its "passes through the gap" scenario no longer applies because clouds have no gap, and the cloud contact rule changes from bounding boxes to ellipses.
**Migration**: Replaced by "Collision with cloud, ground or ceiling ends the run".

## ADDED Requirements

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
