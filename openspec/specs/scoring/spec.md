# scoring Specification

## Purpose

Defines how a run is scored, how the best score is kept between launches, and what score text the player sees during play and on game over.

## Requirements

### Requirement: Score increases once per cloud group passed
During a run, the score SHALL increase by 1 each time the trailing edge of a cloud group moves left of the plane's trailing edge, which is the plane's left edge at `GameConfig.planeStartX`. Each group SHALL be counted at most once.

#### Scenario: Passing a group scores a point
- **WHEN** the right edge of a group's clouds moves from at or right of the plane's left edge to left of it during a run
- **THEN** the score increases by 1

#### Scenario: Two-cloud group counts once
- **WHEN** a group containing two clouds is passed
- **THEN** the score increases by exactly 1, not 2

#### Scenario: Group counted only once
- **WHEN** a group has already been counted and the run continues
- **THEN** that group never increases the score again

#### Scenario: Group overlapping the plane is not yet passed
- **WHEN** a group's right edge is still at or right of the plane's left edge
- **THEN** no point is awarded for that group

#### Scenario: Large frame step passes several groups
- **WHEN** one update moves more than one group past the plane's left edge
- **THEN** the score increases by 1 for each such group

### Requirement: Score starts at zero and resets each run
The score SHALL be 0 at launch and SHALL be reset to 0 when a new run is prepared after game over.

#### Scenario: Fresh launch
- **WHEN** the app launches
- **THEN** the score is 0

#### Scenario: Restart clears score
- **WHEN** the player restarts after a game over with a non-zero score
- **THEN** the score is 0 in the new run

### Requirement: No score after the run has ended
Once the run has ended, the score SHALL NOT change. A point for a group passed in the same update as the collision SHALL NOT be awarded.

#### Scenario: Crash on the first group
- **WHEN** the plane crashes into the first group before passing it
- **THEN** the final score is 0

#### Scenario: Pass and crash in the same update
- **WHEN** the plane passes a group and collides in the same update
- **THEN** the collision ends the run and that group's point is not awarded

#### Scenario: Frozen scene after game over
- **WHEN** the game is in the game-over state
- **THEN** the score remains equal to its value at the moment of the crash

### Requirement: High score is updated only when beaten
At game over, the high score SHALL be replaced by the final score only if the final score is strictly greater than the current high score. Otherwise the high score SHALL be unchanged.

#### Scenario: New best
- **WHEN** a run ends with a final score greater than the high score
- **THEN** the high score becomes the final score and is saved

#### Scenario: Tying the high score
- **WHEN** a run ends with a final score equal to the high score
- **THEN** the high score is unchanged, nothing is saved and no new best is indicated

#### Scenario: Lower score
- **WHEN** a run ends with a final score below the high score
- **THEN** the high score is unchanged and nothing is saved

#### Scenario: First run on a fresh install
- **WHEN** a run ends with a final score of 1 or more and no high score has ever been stored
- **THEN** the high score is treated as 0, becomes the final score, is saved and a new best is indicated

#### Scenario: Score of zero on a fresh install
- **WHEN** a run ends with a final score of 0 and no high score has ever been stored
- **THEN** the high score stays 0, nothing is saved and no new best is indicated

### Requirement: High score is saved at game over only
The high score SHALL be written to storage at game over, at most once per run, and SHALL NOT be written while the run is in progress.

#### Scenario: No writes during play
- **WHEN** the score increases during a run
- **THEN** nothing is written to storage

#### Scenario: One write per run
- **WHEN** a run ends with a new best
- **THEN** exactly one write of the new high score occurs for that run

### Requirement: High score is loaded at launch with safe fallback
The stored high score SHALL be loaded when the app launches. If the value is missing, not a valid whole number or negative, the high score SHALL be 0.

#### Scenario: Stored value present
- **WHEN** the app launches and a valid non-negative high score is stored
- **THEN** the high score equals the stored value

#### Scenario: Fresh install
- **WHEN** the app launches and no high score is stored
- **THEN** the high score is 0

#### Scenario: Corrupt stored value
- **WHEN** the app launches and the stored value is of the wrong type or unreadable
- **THEN** the high score is 0

#### Scenario: Negative stored value
- **WHEN** the app launches and the stored value is negative
- **THEN** the high score is 0

### Requirement: Storage failures never interrupt play
A failure to read or write the high score SHALL NOT crash the game, block input or change the state transitions of a run. The in-memory high score SHALL remain authoritative for the current session.

#### Scenario: Read failure at launch
- **WHEN** reading the stored high score fails
- **THEN** the game launches normally with a high score of 0

#### Scenario: Write failure at game over
- **WHEN** saving a new high score fails at game over
- **THEN** the game-over state is shown normally, the in-memory high score holds the new value for the rest of the session and play continues

#### Scenario: Later write succeeds
- **WHEN** a write failed in an earlier run and a later run ends with a new best
- **THEN** the write is attempted again with that run's value

### Requirement: Score is shown during play
While the game is in the playing state, the game SHALL display the current score as plain text. The score text SHALL NOT be shown in the ready state.

#### Scenario: Score visible while playing
- **WHEN** the game is in the playing state
- **THEN** the current score is displayed and updates when it changes

#### Scenario: Hidden before the first tap
- **WHEN** the game is in the ready state
- **THEN** no score text is displayed

### Requirement: Game over shows score, high score and new best
In the game-over state, the game SHALL display the final score and the high score as plain text. It SHALL additionally display a "new best" indication if and only if the final score beat the previously stored high score in that run.

#### Scenario: Game over without new best
- **WHEN** a run ends with a score not above the previous high score
- **THEN** the final score and the unchanged high score are shown with no new best indication

#### Scenario: Game over with new best
- **WHEN** a run ends with a score above the previous high score
- **THEN** the final score, the updated high score and a new best indication are shown

#### Scenario: Display survives write failure
- **WHEN** a new best is achieved and saving it fails
- **THEN** the new best indication and the updated high score are still shown
