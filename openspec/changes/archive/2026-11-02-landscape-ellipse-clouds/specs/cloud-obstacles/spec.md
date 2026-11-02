# Spec Delta

## REMOVED Requirements

### Requirement: Cloud pairs scroll toward the plane
**Reason**: Clouds are no longer top and bottom pairs with a gap.
**Migration**: Replaced by "Clouds scroll toward the plane".

### Requirement: Gap size is configured
**Reason**: There is no vertical gap between clouds any more.
**Migration**: Replaced by "Clouds are ellipses of configured size".

### Requirement: Gap position is randomised within safe bounds
**Reason**: Gap positions are replaced by lane selection.
**Migration**: Replaced by "Clouds occupy three lanes".

### Requirement: Pairs are spawned at fixed horizontal spacing
**Reason**: Spawning is per cloud group, not per pair.
**Migration**: Replaced by "Cloud groups are spawned at fixed horizontal spacing".

## ADDED Requirements

### Requirement: Clouds are ellipses of configured size
Every cloud SHALL be an ellipse with the configured width and height, drawn and collided as an ellipse.

#### Scenario: Cloud size is constant
- **WHEN** any cloud is spawned
- **THEN** its width and height equal the configured cloud width and height

#### Scenario: Cloud is not a wall
- **WHEN** a cloud is on screen
- **THEN** its height is less than the height of a lane, so free space remains above and below it

### Requirement: Clouds occupy three lanes
The play area between the ceiling and the ground SHALL be divided into three equal horizontal lanes. Each cloud SHALL be centred vertically in one lane.

#### Scenario: Cloud is centred in its lane
- **WHEN** a cloud is spawned in a lane
- **THEN** the vertical centre of the cloud equals the vertical centre of that lane

#### Scenario: Three lanes exist
- **WHEN** many clouds are spawned
- **THEN** their vertical centres take exactly three distinct values, one per lane

### Requirement: Clouds scroll toward the plane
During a run, clouds SHALL enter from the right edge of the screen and move left at the configured scroll speed.

#### Scenario: Cloud scrolls at constant speed
- **WHEN** a run is in progress
- **THEN** every cloud moves left at the configured scroll speed, independent of frame rate

#### Scenario: Cloud removed after leaving the screen
- **WHEN** a cloud has moved fully past the left edge of the screen
- **THEN** it is removed and no longer takes part in collisions

### Requirement: Cloud groups are spawned at fixed horizontal spacing
Clouds SHALL be spawned in groups. The horizontal distance between consecutive groups SHALL equal the configured spawn spacing, and the first group SHALL appear a configured distance after the run starts.

#### Scenario: Steady spacing
- **WHEN** a run has been in progress long enough to spawn several groups
- **THEN** the horizontal distance between each group and the next equals the configured spawn spacing

#### Scenario: No clouds before the run starts
- **WHEN** the game is in the ready state
- **THEN** no clouds are on screen

### Requirement: A group never blocks all lanes
Each group SHALL contain clouds in one or two lanes, chosen at random, and SHALL NOT contain clouds in all three lanes, so at least one lane is always free of clouds.

#### Scenario: Group size is one or two
- **WHEN** many groups are spawned
- **THEN** every group has either one or two clouds, each in a different lane

#### Scenario: Lane choice varies
- **WHEN** consecutive groups are spawned
- **THEN** their occupied lanes are chosen independently at random, so successive groups are not always identical

#### Scenario: Passage always exists
- **WHEN** any group reaches the plane
- **THEN** the plane can pass it by flying through a free lane, or over or under the clouds
