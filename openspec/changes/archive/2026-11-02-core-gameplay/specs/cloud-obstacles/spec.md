# Spec Delta

## Purpose

Defines the cloud obstacles the plane must steer through: pairs of clouds with a gap, scrolling toward the plane at a steady speed with a randomised gap position.

## ADDED Requirements

### Requirement: Cloud pairs scroll toward the plane
During a run, cloud pairs SHALL move horizontally from the right edge toward the left at the configured scroll speed. Each pair SHALL consist of a top cloud and a bottom cloud separated by a vertical gap.

#### Scenario: Pair scrolls at constant speed
- **WHEN** a run is in progress
- **THEN** every cloud pair moves left at the configured scroll speed, independent of frame rate

#### Scenario: Pair removed after leaving the screen
- **WHEN** a cloud pair has moved fully past the left edge of the screen
- **THEN** it is removed and no longer takes part in collisions

### Requirement: Gap size is configured
The vertical gap between the top and bottom cloud of every pair SHALL equal the configured gap size.

#### Scenario: Gap size is constant in this change
- **WHEN** any cloud pair is spawned
- **THEN** its gap height equals the configured gap size

### Requirement: Gap position is randomised within safe bounds
The vertical position of each gap SHALL be chosen at random, such that the gap never comes closer to the ceiling or the ground than the configured minimum margin.

#### Scenario: Gap stays within margins
- **WHEN** many cloud pairs are spawned
- **THEN** every gap lies entirely between the ceiling margin and the ground margin

#### Scenario: Gap positions vary
- **WHEN** consecutive cloud pairs are spawned
- **THEN** their gap positions are drawn independently at random, so successive gaps are not identical

#### Scenario: Consecutive gaps stay reachable
- **WHEN** a new pair is spawned after a previous pair
- **THEN** the vertical distance between the two gap centres does not exceed the configured maximum gap shift

### Requirement: Pairs are spawned at fixed horizontal spacing
New cloud pairs SHALL be spawned so that the horizontal distance between consecutive pairs equals the configured spawn spacing. The first pair SHALL appear a configured distance after the run starts.

#### Scenario: Steady spacing
- **WHEN** a run has been in progress long enough to spawn several pairs
- **THEN** the horizontal distance between each pair and the next equals the configured spawn spacing

#### Scenario: No clouds before the run starts
- **WHEN** the game is in the ready state
- **THEN** no cloud pairs are on screen
