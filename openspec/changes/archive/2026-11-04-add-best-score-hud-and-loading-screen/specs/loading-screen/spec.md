# Spec Delta

## Purpose
Defines the loading screen shown from app launch until the game is ready and the main menu appears.

## ADDED Requirements

### Requirement: Loading screen at launch
From app launch until the game has finished loading, the app SHALL show a loading screen with the game title, a progress indicator and a loading label. No game scene, menu or input SHALL be available while it is shown.

#### Scenario: Launch shows loading first
- **WHEN** the app launches
- **THEN** the loading screen is shown before the main menu

#### Scenario: Menu follows loading
- **WHEN** loading finishes
- **THEN** the loading screen is replaced by the main menu with the saved high score and mute state already applied

#### Scenario: Taps during loading
- **WHEN** the player taps while the loading screen is shown
- **THEN** nothing happens and no run starts

### Requirement: Minimum display time
The loading screen SHALL stay visible for at least a short configured minimum time, even if loading finishes sooner, so that it does not flash on screen. It SHALL NOT stay longer than needed once the minimum time has passed and loading is complete.

#### Scenario: Fast load
- **WHEN** loading completes before the minimum time
- **THEN** the loading screen remains until the minimum time has elapsed

#### Scenario: Slow load
- **WHEN** loading takes longer than the minimum time
- **THEN** the loading screen remains until loading completes and then goes away immediately

### Requirement: Loading never blocks the app
A failure while loading the saved score, the mute setting or audio SHALL NOT keep the loading screen visible indefinitely or crash the app; the menu SHALL appear with default values.

#### Scenario: Failing storage
- **WHEN** reading saved values fails at launch
- **THEN** the loading screen ends normally and the menu appears with defaults

### Requirement: Loading screen only at cold start
The loading screen SHALL be shown only when the app starts, not when returning to the menu from a run.

#### Scenario: Return to menu
- **WHEN** the player returns to the main menu from pause or game over
- **THEN** the loading screen is not shown

### Requirement: No blank flash before the loading screen
The native launch screen shown by the operating system before the app draws SHALL use the same sky colour as the loading screen, so the start-up does not show a white or black flash.

#### Scenario: Cold start on Android
- **WHEN** the app is started
- **THEN** the first frame the player sees is the sky colour, followed by the loading screen
