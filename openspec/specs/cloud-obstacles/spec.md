# cloud-obstacles Specification

## Purpose

Defines the cloud obstacles the plane must steer through: pairs of clouds with a gap, scrolling toward the plane at a steady speed with a randomised gap position.

## Requirements

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
During a run, clouds SHALL enter from the right edge of the screen and move left at the current scroll speed. The current scroll speed SHALL start at the configured base scroll speed and increase by a configured amount for each point scored, never exceeding the configured maximum scroll speed. The spawn spacing between groups SHALL NOT change as the speed increases.

#### Scenario: Cloud scrolls at constant speed
- **WHEN** a run is in progress and the score is unchanged
- **THEN** every cloud moves left at the current scroll speed, independent of frame rate, and at the configured base scroll speed when the score is 0

#### Scenario: Speed rises with score
- **WHEN** the score increases during a run
- **THEN** clouds move faster than at the previous score, by the configured amount per point

#### Scenario: Speed is capped
- **WHEN** the score is high enough that the ramp would exceed the maximum
- **THEN** clouds move at the configured maximum scroll speed and no faster

#### Scenario: Speed resets each run
- **WHEN** a new run starts after a restart or return to the menu
- **THEN** the scroll speed is the base scroll speed again

#### Scenario: Cloud removed after leaving the screen
- **WHEN** a cloud has moved fully past the left edge of the screen
- **THEN** it is removed and no longer takes part in collisions

#### Scenario: Passage stays possible at maximum speed
- **WHEN** the scroll speed is at its maximum
- **THEN** every group can still be passed by flying through a free lane, or over or under the clouds

### Requirement: Cloud groups are spawned at fixed horizontal spacing
Clouds SHALL be spawned in groups. Every cloud SHALL belong to exactly one group, and all clouds of a group SHALL share one identity that is unique among groups within a run and stays the same for the group's lifetime, so a group can be recognised as a single unit. The horizontal distance between consecutive groups SHALL equal the configured spawn spacing, and the first group SHALL appear a configured distance after the run starts.

#### Scenario: Steady spacing
- **WHEN** a run has been in progress long enough to spawn several groups
- **THEN** the horizontal distance between each group and the next equals the configured spawn spacing

#### Scenario: No clouds before the run starts
- **WHEN** the game is in the ready state
- **THEN** no clouds are on screen

#### Scenario: Clouds of one group share an identity
- **WHEN** a group of two clouds is spawned
- **THEN** both clouds report the same group identity

#### Scenario: Groups have distinct identities
- **WHEN** several groups are spawned in one run
- **THEN** no two groups share an identity

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
