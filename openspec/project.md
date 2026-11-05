# Project: Fright Flight

## Purpose
Fright Flight is a free, ad-supported, one-tap endless arcade game for **Android**.
The player taps to keep a small aeroplane in the air and flies over, under and
between elliptical cloud obstacles. One point per cloud group passed. A run ends on
collision with a cloud or the ground or the top/bottom bounds.

This is a solo project. It is also a learning project for spec-driven development with
OpenSpec and Claude Code, and a reusable template for future small games.

## Platform scope
- **Android only** for v1. Min SDK 23 (required by google_mobile_ads; verify against the
  plugin's current docs). Target the SDK level Google Play currently requires for new apps.
- **iOS is out of scope.** Do not add iOS-specific code, config, ATT prompts or Apple
  store work. Keep the Dart code platform-neutral so iOS can be added later, but do not
  build or test it now.
- Landscape orientation only (either direction). Phones only; tablets just need to not break
## Tech stack
- Flutter (latest stable) and Dart, with null safety and `flutter_lints` (or `very_good_analysis`).
- **Flame** engine for the game loop, components, collisions and sprites.
- State outside the game loop (menus, settings): keep it simple, `ChangeNotifier` or
  Riverpod. Do not over-engineer.
- `shared_preferences` for the high score and settings.
- `google_mobile_ads` (AdMob) for ads. Use Google's **test ad unit IDs** in debug and
  profile builds, and real IDs only in release builds, injected through build config
  (not hard-coded in source, and never committed with real IDs in debug paths).
- Audio: Flame audio or `audioplayers`; keep it behind a small `AudioService`.
- Firebase Crashlytics: later, in the release-readiness change.
- also i Would like to use vs code which is already installed with flutter extention or widget for development and debugging

## Developer context
The developer is experienced with C# and Angular/TypeScript and new to Dart and Flutter.
When writing Dart, prefer clear and idiomatic code with short comments where Dart/Flutter
differs from C#/Angular (for example async/await, streams, widget lifecycle, immutability).
Do not explain basics at length.

## Conventions
- Folder layout under `lib/`:
  - `game/` Flame world, components (`plane`, `cloud`, `background`), systems
  - `ui/` menu, game-over, pause and settings screens
  - `services/` `ads_service`, `audio_service`, `storage_service`
  - `core/` constants, config, utilities
- All gameplay tuning values (gravity, flap impulse, scroll speed, lane and cloud size, spawn
  spacing, difficulty ramp) live in one `GameConfig` constants file. Specs refer to them
  by name, never by raw number, so tuning does not need a code rewrite.
- Game logic (scoring, collision rules, difficulty curve, ad frequency rules) must be
  separable from Flame rendering so it can be unit tested without a running game.
- Small files, small functions. No dead code. No TODOs left without a spec reference.
- Commit after each completed OpenSpec change. Conventional Commits style.
- Run `dart format`, `flutter analyze` and `flutter test` before marking any task done.

## Game rules (baseline for specs)
- Single input: tap anywhere to flap. The plane has gravity and a flap impulse.
- Cloud obstacles are ellipses in three horizontal lanes. Each group fills one or two
  lanes, never all three, so a free lane always exists. Scroll speed, spawn spacing and
  the share of two-cloud groups ramp up to a set score (`rampEndScore`, 60) and then
  hold, capped so the game stays fair and always completable (checked by a bot
  simulation test). From a set score some single clouds drift within their lane.
- Score +1 when the plane passes a cloud group. High score persists locally.
- Collision with a cloud or the ground ends the run immediately. The ceiling does not:
  it stops the plane, which then falls.
- Game states: `menu`, `ready` (plane hovers, "TAP TO FLY"), `playing`, `paused`,
  `gameOver`.

## Ads policy (applies to the `ads` change, deferred to version 2)
- Interstitial: at most once every N game-overs (N configurable, start at 3), never
  during a run, never within the first 2 runs of a fresh install, and with a minimum
  time gap between interstitials.
- Rewarded ad: optional "continue once" after a crash. Once per run maximum. Player
  must always be able to decline.
- Banner: optional, menu screen only, never during gameplay.
- Ads must never block or delay input, and the game must work fully when ads fail
  to load (no-fill, offline). Ad failure is a normal case, not an error state.
- Show the Google UMP consent form where required before requesting ads.
- Publish `app-ads.txt` on the developer website and a privacy policy URL before release.
- Never click or test with real ad IDs on the developer's own devices.

## Originality and legal
- All art, sound and text must be original or properly licensed. Keep a record of
  licenses in `ASSETS.md`. Do not copy any Flappy Bird art, sound or UI.
- Check name availability on Google Play before finalising the store listing.

## Testing
- Unit tests for scoring, collision rules, difficulty ramp, ad-frequency logic and
  storage service.
- A small number of widget tests for menu and game-over flows.
- Manual device checklist per release: tap latency, pause/resume, interruption by
  calls, low-end device frame rate, offline ad behaviour.

## Release (Android)
- Personal Play developer account: run a **closed test with 12+ testers for 14
  continuous days** before applying for production access. Start this early (see
  roadmap) because the 14 days cannot be shortened.
- Build as an Android App Bundle (`flutter build appbundle`). Enable R8/obfuscation
  and save the symbol files.
- Keep the upload keystore backed up outside the repo. Never commit it.

## Roadmap: OpenSpec changes (in order)
Each item is one OpenSpec change (propose, review, apply, archive).

1. `core-gameplay`: plane, gravity, tap-to-flap, scrolling clouds, collision, game over.
2. `scoring-and-persistence`: score, high score, storage service.
3. `screens-and-flow`: main menu, ready/playing/game-over states, restart, pause.
4. `release-readiness-min`: app name, icon, package id, signing, first App Bundle,
   privacy policy. **After this change, upload to Play closed testing and start the
   14-day clock.**
5. `art-audio-polish`: parallax sky, plane tilt, sound effects, haptics, tuned
   difficulty curve (done during the closed-test wait).
6. `release-final`: Crashlytics, store listing assets, production release after Play
   grants production access. (`app-ads.txt` is only needed once ads exist.)

### Version 2 (deferred)
- `ads`: AdMob integration per the ads policy above, with test IDs, UMP consent,
  graceful failure. Needs `app-ads.txt` and updates to the privacy policy and the Play
  Data safety form.

## Non-goals for v1
Ads (AdMob; see Version 2), iOS, in-app purchases (including "remove ads"), online leaderboards, multiple
characters, accounts or login, localisation beyond English, tablet layouts.

## Working agreement with Claude Code
- Propose before building. Do not implement anything that is not in an approved spec.
- If a spec is ambiguous, ask before guessing; if a requirement turns out impractical,
  update the spec first and then the code.
- Keep each change small enough to review in one sitting.
- After applying a change, summarise what changed, what was tested, and anything
  deferred.
