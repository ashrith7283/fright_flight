# Spec Delta

## MODIFIED Requirements

### Requirement: Cloud groups are spawned at fixed horizontal spacing
Clouds SHALL be spawned in groups. Every cloud SHALL belong to exactly one group, and all clouds of a group SHALL share one identity that is unique among groups within a run and stays the same for the group's lifetime, so a group can be recognised as a single unit. The horizontal distance between consecutive groups SHALL equal the configured spawn spacing, and the first group SHALL appear a configured distance after the run starts.

#### Scenario: Steady spacing
- **WHEN** a run has been in progress long enough to spawn several groups
- **THEN** the horizontal distance between each group and the next equals the configured spawn spacing

#### Scenario: No clouds before the run starts
- **WHEN** the game is in the ready state
- **THEN** no clouds are on screen

#### Scenario: Clouds of one group share an identity
- **WHEN** a group of two clouds is spawned
- **THEN** both clouds report the same group identity

#### Scenario: Groups have distinct identities
- **WHEN** several groups are spawned in one run
- **THEN** no two groups share an identity
