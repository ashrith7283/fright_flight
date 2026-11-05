# Tasks

## 1. Low-latency effect voices

- [x] 1.1 Add a pure round-robin voice selector with a unit test covering wrap-around and a single-voice case; verify `flutter test` passes the new test
- [x] 1.2 Replace the `AudioPool` effects in `lib/services/audio_service.dart` with low-latency voice sets loaded in `preload` (flap 3, score 2, crash 1), played with `stop()` then `resume()` round-robin, keeping the muted check and `_safe`; verify `flutter analyze` is clean and `flutter test` (including `sound_test.dart`) passes
- [ ] 1.3 Build a release APK and verify with the developer on a device that taps with sound on are as smooth as with sound muted, flap/score/crash still play, rapid taps overlap, and mute still silences effects

## Workflow follow-up

- If 1.3 shows a remaining hitch, record the finding and apply the fallback from design.md before archiving.
- Archive the change after the developer confirms smooth taps.
