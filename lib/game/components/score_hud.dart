import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

import '../../core/game_config.dart';
import '../logic/run_controller.dart';
import '../logic/score_keeper.dart';
import '../logic/score_text.dart';

/// Plain-text score readout. Best only in ready; live score and best while
/// playing or paused; nothing in menu and game over (the game-over panel
/// shows the result). Holds no score state itself.
class ScoreHud extends PositionComponent {
  ScoreHud({required this.score, required this.runState}) : super(priority: 10);

  final ScoreKeeper score;
  final RunState Function() runState;

  int _lastScore = 0;
  double _popT = GameConfig.scorePopDuration; // time since the last point

  /// Current size factor of the live score: [GameConfig.scorePopScale] right
  /// after a point, easing back to 1 over [GameConfig.scorePopDuration].
  double get popScale {
    if (_popT >= GameConfig.scorePopDuration) return 1;
    final left = 1 - _popT / GameConfig.scorePopDuration;
    return 1 + (GameConfig.scorePopScale - 1) * left * left;
  }

  @override
  void update(double dt) {
    final now = score.score;
    if (now > _lastScore && runState() == RunState.playing) {
      _popT = 0; // a new point restarts the pop from its peak
    } else {
      _popT = (_popT + dt).clamp(0, GameConfig.scorePopDuration);
    }
    if (now < _lastScore) _popT = GameConfig.scorePopDuration; // run reset
    _lastScore = now;
  }

  static TextPaint _paint(double size) => TextPaint(
    style: TextStyle(
      color: GameConfig.scoreTextColor,
      fontSize: size,
      fontWeight: FontWeight.bold,
      shadows: const [
        Shadow(color: Color(0x99000000), blurRadius: 4, offset: Offset(0, 2)),
      ],
    ),
  );

  static final _playingPaint = _paint(GameConfig.scoreFontSize);
  static final _bestPaint = _paint(GameConfig.bestFontSize);

  @override
  void render(Canvas canvas) {
    switch (runState()) {
      case RunState.menu:
        return;
      case RunState.ready:
        _renderBest(canvas, GameConfig.scoreTextY);
      case RunState.playing:
      case RunState.paused:
        // Pop around the left middle of the text so it grows in place.
        const pivotX = GameConfig.scoreTextX;
        const pivotY = GameConfig.scoreTextY + GameConfig.scoreFontSize / 2;
        canvas.save();
        canvas.translate(pivotX, pivotY);
        canvas.scale(popScale);
        canvas.translate(-pivotX, -pivotY);
        _playingPaint.render(
          canvas,
          ScoreText.playing(score.score),
          Vector2(GameConfig.scoreTextX, GameConfig.scoreTextY),
        );
        canvas.restore();
        _renderBest(canvas, GameConfig.bestTextY);
      case RunState.gameOver:
        return; // shown by the game-over panel
    }
  }

  void _renderBest(Canvas canvas, double y) => _bestPaint.render(
    canvas,
    ScoreText.best(score.score, score.highScore),
    Vector2(GameConfig.scoreTextX, y),
  );
}
