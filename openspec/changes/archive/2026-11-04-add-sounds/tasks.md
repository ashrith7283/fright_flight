# Tasks

## 1. Dependency and assets

- [x] 1.1 Add `flame_audio` to `pubspec.yaml` and declare `assets/audio/`; run `flutter pub get`
- [x] 1.2 Choose and download CC0 clips for flap, score, crash and a looping music track into `assets/audio/`, verifying each licence on its source page
- [x] 1.3 Write `assets/audio/CREDITS.md` listing file, source URL and licence for every clip

## 2. Audio service and mute setting

- [x] 2.1 Add `lib/services/audio_service.dart` with the `AudioService` interface and a `FlameAudioService` that never throws
- [x] 2.2 Add `readMuted`/`writeMuted` to `StorageService` and `SharedPreferencesStorageService`; failures degrade to unmuted
- [x] 2.3 Add mute state (`ValueNotifier<bool>`) loaded on startup, persisted on toggle, applied to the audio service

## 3. Game wiring

- [x] 3.1 Play flap on accepted taps, score when points are awarded, and crash on collision in `lib/game/fright_flight_game.dart`
- [x] 3.2 Drive music from run-state transitions: start on Play, pause on pause/app background, resume on resume, stop on crash and return to menu, restart on restart
- [x] 3.3 Preload the effects in `onLoad`
- [x] 3.4 Pass the audio service into the game constructor (default real, fake in tests)

## 4. UI

- [x] 4.1 Add a speaker toggle button to `lib/ui/main_menu.dart` and `lib/ui/pause_menu.dart` bound to the mute state
- [x] 4.2 Wire the mute state and toggle through `lib/main.dart`

## 5. Tests and verification

- [x] 5.1 Unit tests with a fake `AudioService`: flap/score/crash called once per event, no flap on ignored taps, music actions per state transition, muted behaviour
- [x] 5.2 Test mute persistence and storage-failure fallback; update screens tests for the new buttons
- [x] 5.3 Run `flutter analyze` and `flutter test`; confirm gameplay is unchanged
- [x] 5.4 Run the app on a device or emulator and listen: effects, music, pause/resume, game over, mute and relaunch
