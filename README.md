# fright_flight

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

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
