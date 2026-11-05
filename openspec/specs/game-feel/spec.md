# game-feel Specification

## Purpose
Defines the cosmetic feedback that makes scoring, crashing and close calls feel responsive, without ever changing collisions, scoring or timing.

## Requirements

### Requirement: Score pop
Each time the score increases during a run, the live score text SHALL briefly grow by the configured pop scale and return to its normal size within the configured pop duration.

#### Scenario: Score increases
- **WHEN** the score goes up by one during a run
- **THEN** the score text grows and returns to normal size within the pop duration

#### Scenario: Quick successive points
- **WHEN** the score increases again while a pop is still running
- **THEN** the pop restarts from its peak and the text never grows beyond the configured pop scale

### Requirement: Crash impact
When a run ends, the screen SHALL flash white briefly and the view SHALL shake with a decaying offset, both ending within their configured durations. When the device requests reduced motion, the shake SHALL be skipped and the flash kept.

#### Scenario: Crash feedback
- **WHEN** the plane crashes
- **THEN** a white flash fades out and the view shakes and settles back to its normal position within the configured durations

#### Scenario: Reduced motion
- **WHEN** the plane crashes on a device with reduced motion or animations turned off
- **THEN** the flash is shown and the view does not shake

#### Scenario: Restart clears effects
- **WHEN** the player restarts while a shake or flash is still running
- **THEN** the effect stops and the new run starts with the view in its normal position

### Requirement: Near-miss feedback
When the plane finishes passing a cloud group without a collision, and during that pass it came within the configured near-miss margin of any cloud's ellipse, the game SHALL show a short "CLOSE!" label near the plane that rises and fades. A near miss SHALL NOT change the score.

#### Scenario: Close pass
- **WHEN** the plane passes a group and at its closest it was within the near-miss margin of a cloud's ellipse
- **THEN** a "CLOSE!" label appears near the plane and fades out

#### Scenario: Comfortable pass
- **WHEN** the plane passes a group while staying farther than the near-miss margin from every cloud
- **THEN** no label appears

#### Scenario: At most once per group
- **WHEN** the plane passes one group close to two of its clouds
- **THEN** only one label is shown for that group

#### Scenario: No label on a crash
- **WHEN** the plane collides with a cloud of the group
- **THEN** no near-miss label is shown for that group

### Requirement: Feedback never affects gameplay
Score pop, crash impact and near-miss feedback SHALL NOT change collisions, scoring, the restart delay or run timing.

#### Scenario: Outcomes unchanged
- **WHEN** the same run is played with and without these effects
- **THEN** collisions, score and state transitions are identical
