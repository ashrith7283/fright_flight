# Tasks

## 1. App identity

- [x] 1.1 Change `namespace` and `applicationId` to `com.ashrith.frightflight` in `android/app/build.gradle.kts`, move `MainActivity.kt` to `kotlin/com/ashrith/frightflight/` and update its `package`; verify `grep -r "com.example" android lib pubspec.yaml` finds nothing outside generated files
- [ ] 1.2 Set `android:label` to "Fright Flight" in `AndroidManifest.xml` and the Flutter app title if set; verify `flutter build apk --debug` succeeds and the installed app shows the new label and still opens the main menu

## 2. Launcher icon

- [x] 2.1 Add a reproducible script under `tool/` that generates an original 1024px icon foreground (plane) and background (sky), and record it in `ASSETS.md`; verify the generated PNGs exist and look correct
- [x] 2.2 Add `flutter_launcher_icons` as a dev dependency with adaptive-icon config in `pubspec.yaml`, run it, and verify the mipmap and adaptive icon resources are replaced and `flutter build apk --debug` succeeds
- [ ] 2.3 Verify the icon on a device or emulator launcher under a circular mask shows the whole plane

## 3. Signing, shrinking and permissions

- [x] 3.1 Add the `key.properties`-based `upload` signing config with debug fallback and warning in `android/app/build.gradle.kts`, and git-ignore `key.properties`, `*.jks`, `*.keystore` and `build-symbols/`; verify `git check-ignore` matches each and `flutter build apk --release` without the file completes with the warning
- [ ] 3.2 Enable `isMinifyEnabled` and `isShrinkResources` for release; verify the release APK installs and a run plays with sound, haptics and a persisted best score
- [x] 3.3 Verify the merged release manifest has no INTERNET permission (inspect with `aapt dump permissions` or the merged manifest report)
- [x] 3.4 Check the effective `minSdk` is at least 23 and `targetSdk` meets Google Play's current requirement for new apps; raise explicitly if not, and verify with the build output

## 4. Documents

- [x] 4.1 Write `docs/privacy-policy.md` for the no-data-collection build and confirm the contact email with the developer; verify its claims against the code (only `shared_preferences` is used, no network)
- [x] 4.2 Write `ASSETS.md` listing every file under `assets/` plus the icon with source and license; verify no file under `assets/` is missing from it
- [x] 4.3 Write `docs/release.md` covering `keytool` keystore creation and backup, `key.properties` format, the `flutter build appbundle --release --obfuscate --split-debug-info=build-symbols` command, GitHub Pages setup for the policy, Play closed-test steps, and the manual device checklist; verify by following the build command as written

## 5. Integration

- [x] 5.1 Run `dart format`, `flutter analyze` and `flutter test`; verify all pass
- [x] 5.2 Build the obfuscated release App Bundle with the documented command (with a throwaway local test keystore kept outside the repo) and verify the `.aab` and symbols directory are produced and `git status` shows neither tracked

## Workflow follow-up

- Developer creates the real upload keystore, backs it up, and enables GitHub Pages for `docs/`.
- Developer checks "Fright Flight" availability on Google Play, creates the app, uploads the first bundle to closed testing and recruits 12+ testers; the 14-day clock starts at that upload.
- Archive the change after the first bundle is built and committed.
