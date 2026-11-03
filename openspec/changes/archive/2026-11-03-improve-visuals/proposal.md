# Proposal

## Why

The game currently draws the plane as a red rounded rectangle, clouds as flat grey ellipses, and the world as two solid colour bands. It reads as a prototype; the plane is not recognisable as an aeroplane, and the clouds and background don't look like a sky.

## What Changes

- Draw the plane as a recognisable side-view aeroplane (fuselage, nose, cockpit window, wing, tail fin, propeller) in the same footprint as today.
- Draw each cloud as a soft, puffy cloud silhouette made of overlapping lobes with light shading, within the same bounding ellipse.
- Replace the flat sky/ground with a vertical sky gradient, a sun, and a ground with hills/horizon detail. No background clouds, so the only clouds on screen are obstacles.
- Restyle the main-menu title, best score and Play button.
- Background decoration is purely cosmetic and slowly scrolls for a sense of motion while a run is in progress.
- No change to gameplay, hitboxes, lanes, speeds or scoring.

## Capabilities

### New Capabilities
- `visual-style`: How the plane, clouds and background look, and the guarantee that the visuals never alter collision or gameplay geometry.

### Modified Capabilities
<!-- None: cloud-obstacles still describes clouds as ellipses for size/collision; rendering is covered by visual-style. -->

## Impact

- `lib/game/components/plane_component.dart`, `cloud_component.dart`, `background_component.dart` (rendering only).
- Possibly new small painter helpers under `lib/game/components/` or `lib/game/render/`.
- `lib/core/game_config.dart`: palette/visual constants only.
- No new dependencies or asset files (all drawn procedurally with `Canvas`).
- Out of scope: sprite/image assets, animations of the plane beyond propeller spin and tilt, menu/overlay restyling, sound.
