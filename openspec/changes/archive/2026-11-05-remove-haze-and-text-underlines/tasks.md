# Tasks

## 1. Remove haze ovals

- [x] 1.1 Remove `_haze` paint, `_hazeOffset`, its update, and the oval-drawing loop from `lib/game/components/background_component.dart`; verify `flutter analyze` is clean and background tests still pass
- [x] 1.2 Remove `bgHazeParallax` and `hazeColor` from `lib/core/game_config.dart`; verify `grep -ri haze lib test` returns nothing
- [x] 1.3 Update the doc comment of `BackgroundComponent` to drop "haze"; verify by reading the file

## 2. Remove text underlines

- [x] 2.1 Wrap app content in a transparent `Material` through `MaterialApp.builder` in `lib/main.dart`; verify by running the app that titles and labels show no yellow underline
- [x] 2.2 Add a widget test in `test/ui_style_test.dart` that pumps the app-level wrapper with each overlay and asserts no `Text` renders with a `TextDecoration.underline` (using the default style resolved in context); verify `flutter test` passes

## 3. Integration

- [x] 3.1 Run `flutter analyze` and `flutter test`; verify all pass with no regressions
