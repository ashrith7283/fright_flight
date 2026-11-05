# Proposal

## Why

The game stops changing after about 40 points: speed rises only from 220 to 260 and then stays flat, spacing never changes, and every group is an independent random pick of one or two clouds. Long runs become monotonous. The ready screen is static with no instruction, so a new player sees a frozen plane and no hint to tap. Touching the top of the screen ends the run, which players often see as unfair. The developer chose a moderate difficulty: noticeably harder by about 60 points, then steady, and always fair.

## What Changes

- **Difficulty ramp**: speed rises from 220 to a cap of 300 at score 60; spawn spacing shrinks from 460 to 380 over the same range; the share of two-cloud groups rises from even odds to a configured higher share. All values live in `GameConfig`.
- **Moving clouds**: from a configured score, some single-cloud groups drift slowly up and down within their lane; collisions follow the drawn position.
- **Living ready screen**: the plane hovers and bobs gently, and a pulsing "TAP TO FLY" prompt is shown until the first tap. The run starts from the plane's current position.
- **Soft ceiling**: the top of the screen stops the plane instead of ending the run. **BREAKING** for the current rule that the ceiling is a collision.
- Update the "Game rules" section of `openspec/project.md` to match (ceiling no longer kills, ramp described).

## Capabilities

### New Capabilities

### Modified Capabilities
- `cloud-obstacles`: spacing shrinks with score; speed cap and ramp change; two-cloud share rises with score; some clouds move within their lane.
- `plane-control`: the plane hovers in the ready state; the ceiling stops the plane instead of colliding.
- `run-lifecycle`: ready state shows a tap prompt and a hovering plane; the ceiling no longer ends a run.

## Impact

- `lib/core/game_config.dart`, `lib/game/logic/difficulty_curve.dart`, `cloud_field.dart`, `lane_picker.dart`, `cloud_spec.dart`, `collision_rules.dart`, `plane_body.dart`, `lib/game/fright_flight_game.dart`, `lib/game/components/score_hud.dart` (or a new ready-prompt component), `cloud_component.dart`.
- Tests: `difficulty_curve_test`, `cloud_field_test`, `lane_picker_test`, `collision_rules_test`, `plane_body_test`, `lane_fit_and_simulation_test`, `game_over_flow_test`, `screens_test` need updates or additions.
- `openspec/project.md` game rules.
- No change to scoring, audio, storage or UI panels.
