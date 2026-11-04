import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fright_flight/ui/game_over_panel.dart';
import 'package:fright_flight/ui/glass_icon_button.dart';
import 'package:fright_flight/ui/loading_screen.dart';
import 'package:fright_flight/ui/main_menu.dart';
import 'package:fright_flight/ui/pause_menu.dart';
import 'package:fright_flight/ui/pill_button.dart';
import 'package:fright_flight/ui/settings_toggles.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

Widget _panel({
  required ValueNotifier<bool> ready,
  bool newBest = false,
  int score = 12,
  int best = 20,
  VoidCallback? onRestart,
  VoidCallback? onMenu,
}) => _wrap(
  GameOverPanel(
    score: score,
    best: best,
    newBest: newBest,
    restartReady: ready,
    onRestart: onRestart ?? () {},
    onMenu: onMenu ?? () {},
  ),
);

void main() {
  group('game-over panel', () {
    testWidgets('shows score and best at once, no new-best badge', (t) async {
      await t.pumpWidget(_panel(ready: ValueNotifier(false)));
      expect(find.text('GAME OVER'), findsOneWidget);
      expect(find.text('12'), findsOneWidget);
      expect(find.text('BEST  20'), findsOneWidget);
      expect(find.text('NEW BEST'), findsNothing);
    });

    testWidgets('new-best badge only when earned', (t) async {
      await t.pumpWidget(
        _panel(ready: ValueNotifier(true), newBest: true, score: 25, best: 25),
      );
      expect(find.text('NEW BEST'), findsOneWidget);
      expect(find.text('25'), findsOneWidget);
    });

    testWidgets('buttons disabled until ready, then call back', (t) async {
      final ready = ValueNotifier(false);
      var restarted = 0, menu = 0;
      await t.pumpWidget(
        _panel(
          ready: ready,
          onRestart: () => restarted++,
          onMenu: () => menu++,
        ),
      );
      await t.tap(find.text('RESTART'));
      await t.tap(find.text('MENU'));
      expect((restarted, menu), (0, 0));

      ready.value = true;
      await t.pump();
      await t.tap(find.text('RESTART'));
      await t.tap(find.text('MENU'));
      expect((restarted, menu), (1, 1));
    });
  });

  group('settings toggles', () {
    testWidgets('reflect state, call back and expose labels', (t) async {
      final muted = ValueNotifier(false);
      final vibration = ValueNotifier(true);
      var m = 0, v = 0;
      await t.pumpWidget(
        _wrap(
          SettingsToggles(
            muted: muted,
            onToggleMute: () => m++,
            vibration: vibration,
            onToggleVibration: () => v++,
          ),
        ),
      );
      expect(find.bySemanticsLabel('Mute'), findsOneWidget);
      expect(find.bySemanticsLabel('Vibration on'), findsOneWidget);
      await t.tap(find.byIcon(Icons.volume_up));
      await t.tap(find.byIcon(Icons.vibration));
      expect((m, v), (1, 1));

      muted.value = true;
      vibration.value = false;
      await t.pump();
      expect(find.byIcon(Icons.volume_off), findsOneWidget);
      expect(find.byIcon(Icons.mobile_off), findsOneWidget);
      expect(find.bySemanticsLabel('Unmute'), findsOneWidget);
      expect(find.bySemanticsLabel('Vibration off'), findsOneWidget);
    });
  });

  group('layout', () {
    Future<void> shortLandscape(WidgetTester t, Widget w) async {
      t.view.physicalSize = const Size(640, 300);
      t.view.devicePixelRatio = 1;
      addTearDown(t.view.reset);
      await t.pumpWidget(w);
      await t.pump(const Duration(milliseconds: 400));
      expect(t.takeException(), isNull);
    }

    testWidgets('main menu fits a short landscape screen', (t) async {
      await shortLandscape(
        t,
        _wrap(
          MainMenu(
            highScore: 3,
            onPlay: () {},
            muted: ValueNotifier(false),
            onToggleMute: () {},
            vibration: ValueNotifier(true),
            onToggleVibration: () {},
          ),
        ),
      );
    });

    testWidgets('pause menu, game over and loading fit too', (t) async {
      await shortLandscape(
        t,
        _wrap(
          PauseMenu(
            onResume: () {},
            onMenu: () {},
            muted: ValueNotifier(false),
            onToggleMute: () {},
            vibration: ValueNotifier(true),
            onToggleVibration: () {},
          ),
        ),
      );
      await shortLandscape(
        t,
        _panel(ready: ValueNotifier(true), newBest: true),
      );
      await shortLandscape(t, _wrap(const LoadingScreen()));
    });

    testWidgets('buttons have at least a 48 dp touch target', (t) async {
      await t.pumpWidget(
        _wrap(
          Column(
            children: [
              PillButton(label: 'a', icon: Icons.add, onPressed: () {}),
              PillButton(
                label: 'b',
                icon: Icons.add,
                onPressed: () {},
                primary: false,
              ),
              GlassIconButton(icon: Icons.add, label: 'c', onPressed: () {}),
            ],
          ),
        ),
      );
      for (final type in [PillButton, GlassIconButton]) {
        for (final e in t.widgetList(find.byType(type))) {
          final size = t.getSize(find.byWidget(e));
          expect(size.height, greaterThanOrEqualTo(48));
          expect(size.width, greaterThanOrEqualTo(48));
        }
      }
    });
  });
}
