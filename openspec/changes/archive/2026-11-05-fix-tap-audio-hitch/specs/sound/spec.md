# Spec Delta

## ADDED Requirements

### Requirement: Effects do not delay input
Playing a sound effect SHALL NOT delay or stall the frame in which the player taps, including when the player taps rapidly. Each tap SHALL still play the flap sound once.

#### Scenario: Smooth taps with sound on
- **WHEN** the player taps repeatedly during a run with sound on
- **THEN** the plane responds and frames render as smoothly as with sound muted

#### Scenario: Rapid taps overlap
- **WHEN** the player taps faster than the flap sound lasts
- **THEN** each tap starts the flap sound and earlier instances may overlap rather than being dropped or queued behind each other
