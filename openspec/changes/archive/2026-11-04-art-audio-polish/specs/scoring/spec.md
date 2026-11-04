# Spec Delta

## MODIFIED Requirements

### Requirement: Game over shows score, high score and new best
In the game-over state, the game SHALL display the final score and the high score in the game-over panel. It SHALL additionally display a "new best" indication if and only if the final score beat the previously stored high score in that run.

#### Scenario: Game over without new best
- **WHEN** a run ends with a score not above the previous high score
- **THEN** the final score and the unchanged high score are shown with no new best indication

#### Scenario: Game over with new best
- **WHEN** a run ends with a score above the previous high score
- **THEN** the final score, the updated high score and a new best indication are shown

#### Scenario: Display survives write failure
- **WHEN** a new best is achieved and saving it fails
- **THEN** the new best indication and the updated high score are still shown
