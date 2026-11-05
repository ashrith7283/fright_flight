# Spec Delta

## Purpose

Gives players goals beyond their best score: a medal for each finished run by score, a hint towards the next medal, and a persisted count of runs played.

## ADDED Requirements

### Requirement: Medal awarded by final score
Each run that ends in game over SHALL earn the highest medal whose configured threshold the final score meets or exceeds, in the order Bronze, Silver, Gold, Platinum. A final score below the Bronze threshold SHALL earn no medal.

#### Scenario: Below bronze
- **WHEN** a run ends with a score below the Bronze threshold
- **THEN** no medal is awarded

#### Scenario: Exactly on a threshold
- **WHEN** a run ends with a score equal to the Silver threshold
- **THEN** a Silver medal is awarded

#### Scenario: Above the top threshold
- **WHEN** a run ends with a score above the Platinum threshold
- **THEN** a Platinum medal is awarded

### Requirement: Game over shows the medal and the next goal
The game-over panel SHALL show the medal earned in that run, if any, and SHALL show how many more points the next higher medal needs and its name. When the run earned Platinum, no next-medal hint SHALL be shown.

#### Scenario: Medal and hint
- **WHEN** a run ends with a score between the Bronze and Silver thresholds
- **THEN** the panel shows the Bronze medal and the number of points still needed for Silver

#### Scenario: No medal yet
- **WHEN** a run ends below the Bronze threshold
- **THEN** the panel shows no medal and shows the points still needed for Bronze

#### Scenario: Top medal
- **WHEN** a run ends with Platinum
- **THEN** the panel shows the Platinum medal and no next-medal hint

### Requirement: Runs played are counted and persisted
The game SHALL count each run that ends in game over as one run played. Runs abandoned from the pause menu SHALL NOT be counted. The count SHALL be written to storage at game over, at most once per run, and loaded at launch. A missing, invalid or negative stored value SHALL be treated as 0.

#### Scenario: Finished run counts
- **WHEN** a run ends in game over
- **THEN** the runs-played count increases by one and is saved once

#### Scenario: Abandoned run does not count
- **WHEN** the player leaves a run through the pause menu
- **THEN** the runs-played count is unchanged and nothing is saved

#### Scenario: Count survives relaunch
- **WHEN** the app is relaunched after several finished runs
- **THEN** the runs-played count equals the number of finished runs

#### Scenario: Corrupt stored count
- **WHEN** the stored count is missing, negative or not a whole number
- **THEN** the count starts at 0

### Requirement: Menu shows runs played and best medal
The main menu SHALL show the runs-played count and the medal earned by the current high score, if any.

#### Scenario: Fresh install
- **WHEN** the menu is shown on a fresh install
- **THEN** it shows 0 runs played and no medal

#### Scenario: After good runs
- **WHEN** the high score meets the Gold threshold
- **THEN** the menu shows the Gold medal next to the best score

### Requirement: Stats failures never interrupt play
A failure to read or write the runs-played count SHALL NOT crash the game, block input or change run transitions. The in-memory count SHALL stay authoritative for the session.

#### Scenario: Write failure
- **WHEN** saving the runs-played count fails at game over
- **THEN** the game-over panel is shown normally and the in-memory count keeps the new value
