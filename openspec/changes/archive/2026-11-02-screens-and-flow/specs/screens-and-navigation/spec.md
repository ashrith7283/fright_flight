# Spec Delta

## ADDED Requirements

### Requirement: Main menu at launch
The app SHALL open on a main menu showing the game title, a Play button and the current high score. No run SHALL be in progress while the menu is shown, and taps outside the buttons SHALL NOT start a run.

#### Scenario: Launch shows menu
- **WHEN** the app launches
- **THEN** the main menu is shown with the title, a Play button and the high score

#### Scenario: Play starts the ready state
- **WHEN** the player taps Play on the menu
- **THEN** the menu is hidden and the game is in the ready state

#### Scenario: Tap outside the buttons
- **WHEN** the player taps the menu away from the Play button
- **THEN** nothing happens

#### Scenario: High score shown on return to menu
- **WHEN** the player returns to the menu after a run that set a new high score
- **THEN** the menu shows the updated high score

### Requirement: Pause during play
While the game is in the playing state, a pause button SHALL be visible. Pressing it SHALL freeze the plane, clouds and score, and show a pause overlay with Resume and Menu buttons. The pause button SHALL NOT be shown in any other state, and taps on it SHALL NOT flap the plane.

#### Scenario: Pause freezes the run
- **WHEN** the player presses the pause button during play
- **THEN** the plane and clouds stop moving, the score stays unchanged and the pause overlay is shown

#### Scenario: Pause button hidden outside play
- **WHEN** the game is in the ready, game-over or menu state
- **THEN** the pause button is not shown

#### Scenario: Pressing pause does not flap
- **WHEN** the player presses the pause button
- **THEN** the plane receives no flap impulse

### Requirement: Resume only by button
While paused, a tap outside the overlay buttons SHALL be ignored. Pressing Resume SHALL return to the playing state with the plane, clouds and score exactly as they were when paused.

#### Scenario: Resume continues the run
- **WHEN** the player presses Resume
- **THEN** the pause overlay closes and the run continues from the paused positions with the same score

#### Scenario: Tap while paused
- **WHEN** the player taps outside the overlay buttons while paused
- **THEN** the run stays paused and the plane does not flap

### Requirement: Automatic pause when backgrounded
If the app leaves the foreground while the game is in the playing state, the game SHALL pause. Returning to the app SHALL show the pause overlay and SHALL NOT resume the run automatically.

#### Scenario: App sent to background during play
- **WHEN** the player switches away from the app during play
- **THEN** the game is paused and the pause overlay is shown on return

#### Scenario: App backgrounded outside play
- **WHEN** the app leaves the foreground in the menu, ready or game-over state
- **THEN** the state is unchanged on return

### Requirement: Game-over actions
In the game-over state, once the restart delay has elapsed, Restart and Menu buttons SHALL be shown with the game-over score text. Restart SHALL reset the game to the ready state, as a tap does today. Menu SHALL go to the main menu.

#### Scenario: Buttons appear after the delay
- **WHEN** the game enters the game-over state and the restart delay elapses
- **THEN** the Restart and Menu buttons are shown

#### Scenario: Restart button
- **WHEN** the player presses Restart
- **THEN** the game returns to the ready state with a fresh scene and a score of 0

#### Scenario: Menu button
- **WHEN** the player presses Menu on game over
- **THEN** the main menu is shown and the game-over text and buttons are gone

### Requirement: Leaving a run for the menu
Pressing Menu from the pause overlay SHALL abandon the current run, reset the scene and show the main menu. An abandoned run SHALL NOT change the high score.

#### Scenario: Menu from pause
- **WHEN** the player presses Menu on the pause overlay
- **THEN** the main menu is shown and the next Play starts a fresh run with a score of 0

#### Scenario: Abandoned run does not save
- **WHEN** the player abandons a run whose score is above the high score
- **THEN** the high score is unchanged

### Requirement: Android back button
The Android back button SHALL behave by state: in the playing state it pauses; in the paused state it resumes; in the ready and game-over states it goes to the main menu; on the main menu it exits the app.

#### Scenario: Back while playing
- **WHEN** the player presses back during play
- **THEN** the game pauses and the pause overlay is shown

#### Scenario: Back while paused
- **WHEN** the player presses back while paused
- **THEN** the run resumes

#### Scenario: Back in ready or game over
- **WHEN** the player presses back in the ready or game-over state
- **THEN** the main menu is shown

#### Scenario: Back on the menu
- **WHEN** the player presses back on the main menu
- **THEN** the app exits
