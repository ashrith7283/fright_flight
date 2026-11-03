# Design

## Context

Rendering is three `PositionComponent`s using flat `Canvas` primitives (`plane_component.dart`, `cloud_component.dart`, `background_component.dart`). Collision uses `PlaneBody`/`CloudSpec` logic, independent of rendering. There is no assets folder. See proposal.md for motivation.

## Goals / Non-Goals

**Goals:**
- Recognisable plane, clouds and sky using only Canvas drawing.
- Cheap per-frame cost on mobile (cached paints/paths, no per-frame allocation in hot loops).

**Non-Goals:**
- Image/sprite assets, particle effects, UI overlay restyling, gameplay changes.

## Decisions

- **Procedural vector art, no assets.** Avoids asset pipeline and keeps hitboxes aligned with the configured sizes. Alternative (PNG sprites) needs artwork we don't have.
- **Plane drawn into the existing 48x30 box**, via a `Path`-based painter (fuselage, tail fin, wing, window, nose cone) with a spinning propeller drawn as a thin rotating ellipse/blades. Tilt = `canvas` rotation about the plane centre, angle = clamp(velocity / maxFallSpeed) * ~25°. The component reads `PlaneBody.velocity`; collision geometry still uses unrotated hitbox.
- **Clouds = union of 4-5 circles/ovals** laid out as fractions of cloud width/height, plus a slightly darker lower layer for shading. Lobe layout is a fixed constant list so every cloud looks the same (cheap) with optional mirrored variant by group id. All lobes fit inside the bounding rect.
- **Background**: sky `LinearGradient` shader (cached), sun circle with soft glow, two layers of ground hills in a separate `ParallaxLayer`-style offset that advances only while a run is in progress (driven by the game's run state, speed ≈ 0.2-0.4 x scroll speed, wrapping). The background has no clouds, so players cannot confuse scenery with obstacles.
- **Palette/constants** added to `GameConfig` (or a small `visual_palette.dart`) rather than inlined.

## Risks / Trade-offs

- Procedural art looks stylised rather than polished; acceptable and easy to tweak later or swap for sprites.
- Rotation of the plane could mislead players about the hitbox; hitbox inset stays as is and tilt is limited.
- Gradient shader must be rebuilt only if the size changes to avoid per-frame cost.
