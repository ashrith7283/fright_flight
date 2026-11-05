# ui-style Specification

## Purpose
Defines the shared modern "glass on sky" look of the menus, buttons and panels, so every screen feels consistent and stays readable over the game scene.

## Requirements

### Requirement: Glass panels and pill buttons
The main menu, pause menu, game-over screen and loading screen SHALL present their content using one shared visual style: translucent rounded panels with a soft blur and shadow, and rounded pill-shaped buttons with an icon and label. The primary action (Play, Resume, Restart) SHALL be visually distinct from secondary actions (Menu).

#### Scenario: Consistent style
- **WHEN** any of the menu, pause, game-over or loading screens is shown
- **THEN** it uses the same panel and button styling, colours and corner radii

#### Scenario: Primary action stands out
- **WHEN** a screen has a primary and a secondary action
- **THEN** the primary is filled with the accent colour and the secondary is outlined or translucent

#### Scenario: Readable over the scene
- **WHEN** a panel is shown over the game scene
- **THEN** its text has sufficient contrast against the panel background

### Requirement: Icon toggles for sound and vibration
The sound and vibration settings SHALL be shown as round glass icon buttons grouped together, showing an on or off icon, with a tooltip or accessible label naming the action.

#### Scenario: State shown by icon
- **WHEN** sound or vibration is switched off
- **THEN** its button shows the off icon

#### Scenario: Accessible labels
- **WHEN** a toggle is inspected by assistive technology
- **THEN** it exposes a label such as "Mute" or "Unmute", "Vibration on" or "Vibration off"

### Requirement: Touch targets and layout
Every button SHALL have a touch target of at least 48 logical pixels in both dimensions, and all screens SHALL fit in landscape on small phones without overflow or clipping, respecting safe areas.

#### Scenario: Minimum target size
- **WHEN** any button is laid out
- **THEN** its tappable area is at least 48 by 48 logical pixels

#### Scenario: Small landscape screen
- **WHEN** a screen is shown on a phone with a short landscape height
- **THEN** its content fits without overflow

### Requirement: Screen transitions
Panels SHALL appear with a short fade and scale-in animation. The animation SHALL NOT delay input once the buttons are enabled and SHALL NOT affect the game timing.

#### Scenario: Panel animates in
- **WHEN** a menu, pause or game-over panel appears
- **THEN** it fades and scales in over a short configured time

#### Scenario: Animation does not block input
- **WHEN** a panel is animating in
- **THEN** its buttons already respond to taps unless disabled by the restart delay

### Requirement: Text has no underline decoration
All text on the menu, pause, game-over and loading screens SHALL be drawn without any underline or other text decoration, including the yellow double underline.

#### Scenario: Titles are not underlined
- **WHEN** the main menu, pause menu, game-over panel or loading screen is shown
- **THEN** no title or label text has an underline or other text decoration

#### Scenario: Button and score labels are not underlined
- **WHEN** any button label, score or best-score text is shown on an overlay
- **THEN** it has no text decoration
