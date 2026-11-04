# Spec Delta

## MODIFIED Requirements

### Requirement: Game-over actions
In the game-over state, a game-over panel SHALL be shown immediately with the score information. Restart and Menu buttons SHALL be shown in the panel but SHALL be disabled until the restart delay has elapsed, and enabled after. Restart SHALL reset the game to the ready state, as a tap does today. Menu SHALL go to the main menu.

#### Scenario: Panel appears at once
- **WHEN** the game enters the game-over state
- **THEN** the game-over panel with the score information is shown without waiting for the restart delay

#### Scenario: Buttons appear after the delay
- **WHEN** the restart delay elapses in the game-over state
- **THEN** the Restart and Menu buttons become enabled in the panel

#### Scenario: Buttons disabled before the delay
- **WHEN** the player presses a game-over button before the restart delay has elapsed
- **THEN** nothing happens

#### Scenario: Restart button
- **WHEN** the player presses Restart
- **THEN** the game returns to the ready state with a fresh scene and a score of 0

#### Scenario: Menu button
- **WHEN** the player presses Menu on game over
- **THEN** the main menu is shown and the game-over panel is gone
