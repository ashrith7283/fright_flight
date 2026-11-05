# Proposal

## Why

Scoring and crashing currently have little visual weight. The score text just changes its number. A crash freezes everything instantly, plane included, so the moment of failure feels flat. Skimming past a cloud gives no reward. Small, purely cosmetic feedback ("juice") makes each point feel earned and each crash readable, and gives players a reason to take risks, without touching scoring or collisions.

## What Changes

- **Score pop**: the live score text briefly grows and settles back each time the score increases.
- **Crash impact**: a short screen shake and a quick white flash when the run ends. Shake is skipped when the device asks for reduced motion.
- **Plane falls after a crash**: in game over the clouds stay frozen, but the plane drops nose-down under gravity until it rests on the ground. It no longer freezes in mid-air.
- **Near-miss feedback**: when the plane passes a cloud group very close to a cloud without touching it, a small "CLOSE!" label rises from the plane and fades. Score is unchanged.

## Capabilities

### New Capabilities
- `game-feel`: cosmetic feedback for scoring, crashing and near misses, which never changes gameplay.

### Modified Capabilities
- `run-lifecycle`: in game over the plane falls to the ground instead of freezing in place. Clouds still freeze.

## Impact

- `lib/game/components/score_hud.dart`, `plane_component.dart`, `lib/game/fright_flight_game.dart`, new small components for the flash and the near-miss label, and a new pure `NearMissTracker` in `lib/game/logic/`. `CollisionRules` gains a proximity helper.
- `lib/core/game_config.dart`: new feel constants.
- Tests: new unit tests for the near-miss tracker and the crash fall; flow tests updated for the falling plane.
- Builds on `gameplay-tuning` (the soft ceiling and moving clouds). Apply that change first.
- No change to scoring, storage, audio or UI panels.
