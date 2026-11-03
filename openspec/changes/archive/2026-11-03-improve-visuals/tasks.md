# Tasks

## 1. Palette and constants

- [x] 1.1 Add visual colour constants (plane, cloud, sun, sky gradient stops, hills) and tilt/parallax tuning values to `lib/core/game_config.dart`

## 2. Plane

- [x] 2.1 Replace the rounded rect in `lib/game/components/plane_component.dart` with a path-drawn aeroplane (fuselage, nose, tail fin, wing, cockpit window) fitting the 48x30 footprint
- [x] 2.2 Add velocity-based tilt (clamped) and a spinning propeller that animates only during a run
- [x] 2.3 Confirm `PlaneBody` and collision rules are untouched

## 3. Clouds

- [x] 3.1 Replace the oval in `lib/game/components/cloud_component.dart` with overlapping lobes plus a subtle shaded underside, all inside the cloud bounds

## 4. Background

- [x] 4.1 Draw a vertical sky gradient (still oversized to cover letterbox areas) and a sun in `lib/game/components/background_component.dart`
- [x] 4.2 Add ground hills/horizon detail (no background clouds) with a slow wrapping scroll that advances only while a run is in progress
- [x] 4.3 Hook the background scroll to run state in `lib/game/fright_flight_game.dart`

## 5. Main menu

- [x] 5.1 Restyle the main-menu title, best score and Play button in `lib/ui/main_menu.dart`

## 6. Verification

- [x] 6.1 Run `flutter analyze` and existing tests; confirm collision/scoring behaviour is unchanged
- [x] 6.2 Run the app and visually check ready, running, paused and game-over states at a couple of aspect ratios
