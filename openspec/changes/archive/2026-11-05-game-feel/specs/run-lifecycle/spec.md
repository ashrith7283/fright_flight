# Spec Delta

## MODIFIED Requirements

### Requirement: Game-over state freezes play
In the game-over state, all clouds SHALL stop moving, further flap taps SHALL NOT move the plane, and the score SHALL NOT change. The plane SHALL fall nose-down under gravity from where it crashed until it rests on the ground, without collisions being evaluated. The game-over state SHALL show the final score, the high score and, when the high score was beaten in that run, a new best indication.

#### Scenario: Scene frozen after crash
- **WHEN** the game is in the game-over state
- **THEN** the clouds remain at their positions at the moment of collision, and the plane falls until it rests on the ground and then stays still

#### Scenario: Taps do not move the falling plane
- **WHEN** the player taps during game over before the restart delay has elapsed
- **THEN** the plane keeps falling and receives no flap

#### Scenario: Score and high score shown
- **WHEN** the game enters the game-over state
- **THEN** the final score and the high score are displayed

#### Scenario: New best shown
- **WHEN** the game enters the game-over state with a final score above the previous high score
- **THEN** a new best indication is displayed together with the score and high score
