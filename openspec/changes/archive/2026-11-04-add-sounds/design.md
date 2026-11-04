# Design

## Context

Game logic is Flame-free plain Dart (`RunController`, `ScoreKeeper`, `CloudField`) with Flame components for rendering; the Flutter overlays (`MainMenu`, `PauseMenu`) are built in `lib/main.dart`. Persistence goes through `StorageService` (shared_preferences) with callers degrading on failure. There is no audio dependency or assets folder yet. See proposal.md for motivation and assumptions.

## Goals / Non-Goals

**Goals:** simple, testable sound hooks; failures never reach gameplay; persisted mute.

**Non-Goals:** volume sliders, positional audio, haptics, button-click sounds.

## Decisions

- **`flame_audio` package** (Flame is already used; it wraps audioplayers and provides `FlameAudio.play`, `FlameAudio.bgm` with pause/resume/stop, and lifecycle handling). Alternative: raw `audioplayers` (more code for the same result).
- **`AudioService` interface** (`playFlap`, `playScore`, `playCrash`, `startMusic`, `pauseMusic`, `resumeMusic`, `stopMusic`, `setMuted`) with a `FlameAudioService` implementation and a recording fake for tests. Every method catches and swallows errors (log in debug), matching how `ScoreKeeper` treats storage.
- **Event wiring in `FrightFlightGame`**, not in the pure logic classes: 
  - flap: `RunController` already calls `onFlap`; the game's flap callback plays the sound (it only fires for taps that are accepted).
  - score: `onCloudsAdvanced` already returns points awarded; play when > 0.
  - crash: right where `_run.crash` is called.
  - music: start in `play()`, pause in `pause()` and on app lifecycle non-resumed, resume in `resume()`, stop on crash and `toMenu()`, start again after `restart()`. A small helper maps run-state transitions to music actions after each `_transition`, in the same spirit as `_syncOverlays`, so music cannot drift from state.
- **Mute**: a `SoundSettings` object (ChangeNotifier-style `ValueNotifier<bool> muted`) owned by the game, loaded in `onLoad` via new `readMuted`/`writeMuted` methods on `StorageService`. While muted the service skips effect playback and holds music paused/stopped (volume 0 alternative rejected because it keeps decoding). Toggling unmuted during play resumes music if the state wants music. The speaker buttons listen to the notifier so both menus stay in sync.
- **Assets**: `assets/audio/{flap,score,crash}.wav|ogg` and `music.mp3|ogg`, short clips for effects, a loop under ~1 MB for music, from CC0 sources (e.g. Kenney). `assets/audio/CREDITS.md` lists file, source URL and licence. Format chosen for cross-platform support (the project has android, ios, web, desktop targets): mp3/ogg for music, wav for effects; verify ogg support on iOS before choosing, otherwise use mp3/m4a.
- **Pre-load** effects with `FlameAudio.audioCache.loadAll` in `onLoad` to avoid first-play latency.

## Risks / Trade-offs

- Audio sources must be found and licence-checked manually at implementation time; some candidates may not be truly CC0, so each is verified on its source page.
- Rapid flapping can overlap flap sounds; `FlameAudio.play` allows overlap, acceptable.
- Web autoplay restrictions are avoided by starting music on the Play tap.
- Adding a plugin means native build changes on each platform; verify at least Android debug build.

## Revision: reusable players

First on-device testing showed effects lagging and then going silent over several runs, with music commands arriving late. Cause: `FlameAudio.play` creates a new player per sound and `FlameAudio.bgm.play` re-releases and reloads the track each time. The service now uses reusable `AudioPool`s for effects and one persistent music player whose source is loaded once (stop/start only seek), with music commands serialised in a queue that reconciles to the latest wanted state.
