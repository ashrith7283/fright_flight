# Proposal

## Why

Players feel a brief freeze on each tap. The developer confirmed it disappears when sound is muted, so the flap sound effect causes it. Today each effect uses an `AudioPool` created by `FlameAudio.createPool`, which on Android uses `MediaPlayer`. Every flap runs lock, volume, resume, then on completion a stop and release or seek, all through platform channels. That is heavy work for a sound that fires on every tap, and `MediaPlayer` is known to hitch for short effects.

## What Changes

- Play flap, score and crash effects through pre-loaded low-latency players (Android `SoundPool`) instead of `MediaPlayer` pools. Each effect gets a small fixed set of players created and loaded at startup and reused round-robin, so a tap never creates, loads or releases a player.
- Keep the music player and the `AudioService` interface unchanged; gameplay code is not touched.
- Add a requirement that effects must not delay the frame in which the player taps, including during rapid tapping.

## Capabilities

### New Capabilities

### Modified Capabilities
- `sound`: effects SHALL play without delaying the tap that triggers them.

## Impact

- `lib/services/audio_service.dart` (effect playback only).
- Tests: a unit test for the round-robin voice selection; existing sound tests must still pass.
- No change to assets, mute behaviour, music, haptics or gameplay.
- Out of scope: haptics (the developer reports smooth play with sound off), music handling.
- Cannot be fully verified without a device: the developer must confirm smooth taps on a release build.
