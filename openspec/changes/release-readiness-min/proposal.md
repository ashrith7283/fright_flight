# Proposal

## Why

The game plays well but is still a template build: its package id is `com.example.fright_flight`, the launcher label is `fright_flight`, it uses the default Flutter icon, and release builds are signed with the debug key. Google Play rejects `com.example` ids and debug-signed bundles, and there is no privacy policy URL, which Play requires. Closed testing needs 12+ testers for 14 continuous days, so the first uploadable App Bundle is the critical-path item for the whole release (roadmap item 4).

## What Changes

- Set the permanent Android package id to `com.ashrith.frightflight` and move `MainActivity` to match.
- Set the launcher label and app name to "Fright Flight".
- Replace the default icon with an original plane-in-sky adaptive icon (generated, no third-party art).
- Add release signing driven by an untracked `android/key.properties` and an upload keystore kept outside the repo; ignore both in git.
- Enable R8 minify/shrink for release and document building the App Bundle with `--obfuscate --split-debug-info`, saving symbols outside the repo.
- Write a privacy policy (`docs/privacy-policy.md`) for the current no-data-collection build, to be published with GitHub Pages.
- Add `ASSETS.md` recording the origin and license of art and audio.
- Add a short `docs/release.md` with the build, signing and Play closed-test steps and a manual device checklist.

## Capabilities

### New Capabilities
- `release-packaging`: identity (id, name, icon), release signing, shrunk and obfuscated App Bundle output, and the policy and asset-record documents required to publish.

### Modified Capabilities

## Impact

- `android/app/build.gradle.kts`, `android/app/src/main/AndroidManifest.xml`, `android/app/src/main/kotlin/...` (package move), `android/app/src/main/res/mipmap-*` and adaptive icon resources, `android/.gitignore`/root `.gitignore`, `pubspec.yaml` (dev dependency for icon generation).
- New files: `docs/privacy-policy.md`, `docs/release.md`, `ASSETS.md`, an icon generator script under `tool/`.
- No gameplay, UI or audio behaviour changes. No new runtime permissions.
- Changing the package id is irreversible once uploaded to Play.
- Out of scope: ads, Crashlytics, store listing graphics, `app-ads.txt` (later roadmap changes), iOS.
