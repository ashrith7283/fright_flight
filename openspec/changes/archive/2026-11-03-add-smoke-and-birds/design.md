# Design

## Context

Rendering is component-based (`PlaneComponent`, `CloudComponent`, `BackgroundComponent`) on a fixed 800x400 world; gameplay state lives in `RunController`/`PlaneBody` and is independent of rendering. `BackgroundComponent` and `PlaneComponent` already take an `isRunning` callback. See proposal.md for motivation.

## Goals / Non-Goals

**Goals:** cheap, procedural smoke and birds with no new dependencies; no gameplay coupling.

**Non-Goals:** particle library, assets, sound, birds as hazards.

## Decisions

- **Smoke as its own `SmokeTrail` component** (priority between background and plane, below the plane) that holds a small list of puffs (x, y, age). While running it spawns a puff at the plane tail (`planeX + small offset`, `body.y + planeHeight/2`) every ~0.1 s, moves puffs left at `scrollSpeed`, and draws each as a circle whose radius grows and alpha falls with age (lifetime ~0.8 s). Dead puffs are removed in `update`. The component is told the plane body and `isRunning`; `reset()` clears puffs, called from the game's `_reset`. The game's `update` calls `super.update` in every state, so puff ageing is gated on `isRunning` (puffs freeze while paused or game over rather than vanish).
- **Birds inside `BackgroundComponent`** (or a sibling `BirdsComponent`): 4 birds with fixed (x, y, speed, phase) constants in the upper sky (y < ~140). Each is drawn as two short curved strokes forming a "v" whose wing angle follows `sin(time * flapRate + phase)`. Birds move and flap only while running, using the same `isRunning` gate as the hills, so the scene is still in the menu, ready, paused and game-over states. Speed ~20-40 units/s, wrapping with modulo.
- **Distinguishability**: bird wingspan ~16-22 units, dark slate colour, stroke only; obstacle clouds are 160 wide and white.
- Constants (rates, lifetime, colours, bird table) go in `GameConfig`.

## Risks / Trade-offs

- Many allocations if puffs were objects per frame: bounded by ~8 live puffs; acceptable.
- Smoke drawn at plane tail ignores the plane's tilt; fine at this size (a tiny offset error).
- Birds could still distract; kept small, dark and high, and can be reduced via a config count.
