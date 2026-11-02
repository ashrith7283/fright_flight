import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

import '../../core/game_config.dart';
import '../logic/run_controller.dart';
import '../logic/score_keeper.dart';
import '../logic/score_text.dart';

/// Plain-text score readout. Hidden in ready, live score while playing,
/// score / best / "new best" on game over. Holds no score state itself.
class ScoreHud extends PositionComponent {
  ScoreHud({required this.score, required this.runState}) : super(priority: 10);

  final ScoreKeeper score;
  final RunState Function() runState;

  static TextPaint _paint(double size) => TextPaint(
    style: TextStyle(
      color: GameConfig.scoreTextColor,
      fontSize: size,
      fontWeight: FontWeight.bold,
    ),
  );

  static final _playingPaint = _paint(GameConfig.scoreFontSize);
  static final _gameOverPaint = _paint(GameConfig.gameOverFontSize);

  @override
  void render(Canvas canvas) {
    switch (runState()) {
      case RunState.ready:
        return;
      case RunState.playing:
        _playingPaint.render(
          canvas,
          ScoreText.playing(score.score),
          Vector2(GameConfig.scoreTextX, GameConfig.scoreTextY),
        );
      case RunState.gameOver:
        final lines = ScoreText.gameOver(
          score: score.score,
          highScore: score.highScore,
          newBest: score.newBest,
        );
        for (var i = 0; i < lines.length; i++) {
          _gameOverPaint.render(
            canvas,
            lines[i],
            Vector2(
              GameConfig.gameOverTextX,
              GameConfig.gameOverTextY + i * GameConfig.gameOverLineSpacing,
            ),
            anchor: Anchor.topCenter,
          );
        }
    }
  }
}
