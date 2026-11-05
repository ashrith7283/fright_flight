# Spec Delta

## ADDED Requirements

### Requirement: Text has no underline decoration
All text on the menu, pause, game-over and loading screens SHALL be drawn without any underline or other text decoration, including the yellow double underline.

#### Scenario: Titles are not underlined
- **WHEN** the main menu, pause menu, game-over panel or loading screen is shown
- **THEN** no title or label text has an underline or other text decoration

#### Scenario: Button and score labels are not underlined
- **WHEN** any button label, score or best-score text is shown on an overlay
- **THEN** it has no text decoration
