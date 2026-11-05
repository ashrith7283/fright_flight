# Release guide (Android)

## One-time: upload keystore
Create it outside the repo and **back it up** (a lost upload key can only be reset
through Play support):

```sh
keytool -genkeypair -v -keystore ~/keys/fright-flight-upload.jks \
  -alias upload -keyalg RSA -keysize 2048 -validity 10000
```

Create `android/key.properties` (git-ignored; never commit it or the keystore):

```properties
storeFile=/Users/you/keys/fright-flight-upload.jks
storePassword=...
keyAlias=upload
keyPassword=...
```

Without this file release builds fall back to the debug key and Gradle prints
`WARNING: android/key.properties missing`. Such builds are rejected by Play.

## Build the App Bundle
```sh
dart format . && flutter analyze && flutter test
flutter build appbundle --release --obfuscate --split-debug-info=build-symbols
```
Output: `build/app/outputs/bundle/release/app-release.aab`. Copy `build-symbols/` to a
safe place outside the repo for each release (needed to de-obfuscate crash traces).
Bump `version:` in `pubspec.yaml` (the number after `+` must increase for every upload).

## Icon
`python3 tool/make_icon.py` (needs Pillow) then `dart run flutter_launcher_icons`.

## Privacy policy URL
`docs/privacy-policy.md` is published with GitHub Pages: repository Settings → Pages →
Source "Deploy from a branch", branch `main` (or `dev`), folder `/docs`. The policy URL
is then `https://ashrith7283.github.io/fright_flight/privacy-policy`. Enter it in Play
Console (App content → Privacy policy). Update the policy and the Data safety form when
ads are added.

## Play closed test
1. Check "Fright Flight" is available, then create the app in Play Console.
2. Complete App content (privacy policy, Data safety: no data collected, content rating,
   target audience).
3. Testing → Closed testing → create a release, upload the `.aab`, add 12+ testers.
4. Keep the test running for 14 continuous days, then apply for production access.

## Manual device checklist (per release)
- [ ] Tap latency feels immediate
- [ ] Pause/resume and back button behave
- [ ] Incoming call or app switch pauses the run and resumes cleanly
- [ ] Frame rate acceptable on a low-end phone
- [ ] Sound, music, vibration toggles work and persist
- [ ] Best score persists after closing the app
- [ ] Launcher icon and name correct; adaptive icon masks cleanly
