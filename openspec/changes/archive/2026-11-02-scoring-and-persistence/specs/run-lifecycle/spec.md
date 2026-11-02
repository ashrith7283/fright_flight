# Spec Delta

## MODIFIED Requirements

### Requirement: Game-over state freezes play
In the game-over state, the plane and all clouds SHALL stop moving, further flap taps SHALL NOT move the plane, and the score SHALL NOT change. The game-over state SHALL show the final score, the high score and, when the high score was beaten in that run, a new best indication.

#### Scenario: Scene frozen after crash
- **WHEN** the game is in the game-over state
- **THEN** the plane and clouds remain at their positions at the moment of collision

#### Scenario: Score and high score shown
- **WHEN** the game enters the game-over state
- **THEN** the final score and the high score are displayed

#### Scenario: New best shown
- **WHEN** the game enters the game-over state with a final score above the previous high score
- **THEN** a new best indication is displayed together with the score and high score

### Requirement: Tap restarts after game over
A tap in the game-over state SHALL reset the game to the ready state, with the plane at its starting position, all clouds removed and the score reset to 0. A short, configured delay after the crash SHALL pass before taps are accepted, to prevent an accidental instant restart.

#### Scenario: Restart after delay
- **WHEN** the game is in the game-over state, the restart delay has elapsed, and the player taps
- **THEN** the game returns to the ready state with a fresh scene and a score of 0

#### Scenario: Tap during restart delay
- **WHEN** the player taps before the restart delay has elapsed
- **THEN** the tap is ignored and the game stays in the game-over state

#### Scenario: Game-over text cleared on restart
- **WHEN** the game returns to the ready state after a restart
- **THEN** the game-over score text is no longer displayed
