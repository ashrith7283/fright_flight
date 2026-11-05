# Design

## Context

`FlameAudioService` builds each effect pool with `FlameAudio.createPool`, which creates `AudioPool`s in the default `PlayerMode.mediaPlayer`. `AudioPool.start` takes a lock, reserves or creates a player, sets volume, resumes, and registers a completion listener that later stops and releases or recycles the player. On Android this is several platform-channel calls plus `MediaPlayer` state changes per flap. The developer reports the hitch vanishes with sound muted. `audioplayers_android` offers `PlayerMode.lowLatency` backed by `SoundPool`, where a sound is loaded once and replaying only starts a new stream. See proposal.md for motivation.

## Goals / Non-Goals

**Goals:**
- A tap triggers at most a couple of cheap async calls and never creates, loads or releases a player.
- Overlapping flaps still work.

**Non-Goals:**
- Changing music playback, haptics, assets or the `AudioService` interface.

## Decisions

- **Own small voice pool per effect, `PlayerMode.lowLatency`** (flap 3 voices, score 2, crash 1), each an `AudioPlayer` with the source set once during `preload` and `ReleaseMode.stop`. A tap picks the next voice round-robin, calls `stop()` then `resume()`, restarting the sound from the start. `AudioPool` is rejected for low latency: in that mode it never recycles players (its completion handling is skipped), so it would keep creating players. Alternative: `FlameAudio.play` per tap — rejected, it creates a player each time.
- **Voice selection as a tiny pure class** (`RoundRobin`/index cycling) so it can be unit tested without audio.
- **Keep `_safe` wrapping and the muted check** so failures never reach gameplay and muting stays silent.
- **Preload waits for each source to load** before use so the first tap is not slower than later ones.

## Risks / Trade-offs

- [SoundPool may not fix the hitch] → Developer verifies on a release build; fallback is to decode effects to short buffers or play the first flap from a warmed voice. Task includes the check.
- [`stop()` then `resume()` is two platform calls] → Both are async and fire-and-forget; far lighter than the pool path. If still noisy, skip `stop()` when the voice is idle.
- [SoundPool decodes the whole file into memory] → The effects are tiny; music keeps its own streaming player.
- [Voices must be disposed] → `AudioService` has no dispose today; the app lives for the process, so voices live with it (documented in code).
