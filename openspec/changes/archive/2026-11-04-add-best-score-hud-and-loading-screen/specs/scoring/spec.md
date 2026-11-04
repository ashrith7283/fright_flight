# Spec Delta

## MODIFIED Requirements

### Requirement: Score is shown during play
While the game is in the playing state, the game SHALL display the current score as plain text. The game SHALL also display the best score in the game window whenever the game is in the ready, playing or paused state. The score text SHALL NOT be shown in the ready state. The displayed best score SHALL never be lower than the current score.

#### Scenario: Score visible while playing
- **WHEN** the game is in the playing state
- **THEN** the current score is displayed and updates when it changes

#### Scenario: Hidden before the first tap
- **WHEN** the game is in the ready state
- **THEN** no current-score text is displayed

#### Scenario: Best score visible in the game window
- **WHEN** the game is in the ready, playing or paused state
- **THEN** the best score is displayed in the game window

#### Scenario: Best score on a fresh install
- **WHEN** no high score has been stored
- **THEN** the best score shows 0

#### Scenario: Passing the best score during a run
- **WHEN** the current score exceeds the stored high score during a run
- **THEN** the displayed best score equals the current score and keeps rising with it, while nothing is written to storage until game over

#### Scenario: Best score hidden on the menu
- **WHEN** the main menu is shown
- **THEN** the best score is shown by the menu only, not duplicated in the game window
