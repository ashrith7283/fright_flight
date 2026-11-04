# Spec Delta

## MODIFIED Requirements

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
