# Proposal

## Why

Playtesting `core-gameplay` showed two things the developer does not want: the game is portrait-only, and the clouds are tall wall-like pillars that read as pipes. The game should be landscape, with clouds that look like clouds and let the plane choose to fly over or under them.

## What Changes

- Play in **landscape only** (either landscape direction) instead of portrait. The fixed virtual play area becomes landscape.
- Replace tall top-and-bottom cloud pairs with **elliptical clouds** that enter from the right edge and drift left.
- Arrange clouds in **three horizontal lanes**. Each spawn puts clouds in one or two of the three lanes, never all three, so there is always a free lane. The plane flies over or under the clouds, or through the free lane.
- Collision with a cloud uses the ellipse shape, not its bounding box.
- Remove the vertical "gap" concept (gap size, randomised gap position, maximum gap shift) from clouds. Gap tuning values in `GameConfig` are replaced by lane and ellipse values.
- Rebalance plane physics and world size for the shorter landscape height.
- Update `openspec/project.md`, which still says portrait-only and describes cloud pairs.

**BREAKING**: portrait is no longer supported, and the cloud-pair and gap requirements are removed.

**Out of scope**: score and high score, menus, art, audio, difficulty ramp, hiding system bars.

## Capabilities

### New Capabilities
<!-- None -->

### Modified Capabilities
- `cloud-obstacles`: pairs with a vertical gap are replaced by elliptical clouds in three lanes with a never-all-lanes-blocked spawn rule.
- `run-lifecycle`: the platform presentation requirement becomes landscape-only, and the collision requirement uses ellipse overlap instead of a gap.

`plane-control` is unchanged: gravity, flap, ceiling and ground behave the same, only their tuned values change in `GameConfig`.

## Impact

- `lib/core/game_config.dart`: world size, plane physics, lane and ellipse values replace gap values.
- `lib/game/logic/`: `CloudPairSpec`, `GapGenerator`, `CloudField` and `CollisionRules` are reworked for lane-based ellipses.
- `lib/game/components/cloud_pair_component.dart` becomes an ellipse cloud component. Background and plane components adapt to the new world size.
- `lib/main.dart` and `android/.../AndroidManifest.xml`: orientation lock changes to landscape.
- `test/`: cloud field, gap generator and collision tests are rewritten.
- `openspec/project.md`: orientation and cloud wording.
