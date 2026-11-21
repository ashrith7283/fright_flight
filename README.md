# Fright Flight

A free, one-tap endless arcade game for Android, built with Flutter and Flame. Tap to
keep a little plane in the air, fly over, under and between the clouds, score a point for
every cloud group you pass, and chase the Bronze, Silver, Gold and Platinum medals.

- Landscape, phones, Android only for v1
- No ads, no accounts, no personal data collected
- Specs live in [`openspec/`](openspec/); release steps in [`docs/release.md`](docs/release.md)
  and [`publish-checklist.md`](publish-checklist.md)
- Art and audio credits: [`ASSETS.md`](ASSETS.md). Store listing text and graphics: [`store/`](store/)

## Development

```bash
dart format . && flutter analyze && flutter test
```

## Running on an Android Emulator

1. **Install Flutter and Android Studio.** Follow the
   [Flutter install guide](https://docs.flutter.dev/get-started/install) and
   install [Android Studio](https://developer.android.com/studio), which
   provides the Android SDK and emulator.

2. **Check your setup.** Run the following and fix anything it reports:

   ```bash
   flutter doctor
   ```

3. **Create a virtual device.** In Android Studio, open
   **More Actions → Virtual Device Manager**, click **Create Device**, pick a
   phone (for example, Pixel 8), choose a system image (API 34 or newer), and
   finish the wizard.

4. **Start the emulator.** Either click the **Play** button next to the device
   in Virtual Device Manager, or run:

   ```bash
   flutter emulators                    # list available emulators
   flutter emulators --launch <id>      # launch one by its id
   ```

5. **Confirm Flutter can see it.** Wait for the emulator home screen, then run:

   ```bash
   flutter devices
   ```

   The emulator should appear in the list, for example
   `sdk gphone64 arm64 (mobile) • emulator-5554 • android-arm64`.

6. **Run the app.** From the project folder (`fright_flight`), run:

   ```bash
   flutter pub get
   flutter run -d emulator-5554
   ```

   Use the device id from `flutter devices` if it differs. If more than one
   device is connected, `flutter run` will prompt you to choose one.

To build an installable APK instead, run `flutter build apk`. The output is
written to `build/app/outputs/flutter-apk/`.
