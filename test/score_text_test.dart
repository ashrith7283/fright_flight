import 'package:flutter_test/flutter_test.dart';
import 'package:fright_flight/game/logic/score_text.dart';

void main() {
  test('playing text is the score', () {
    expect(ScoreText.playing(12), '12');
  });

  test('game over lists score and best, plus new best only when earned', () {
    expect(ScoreText.gameOver(score: 3, highScore: 5, newBest: false), [
      'Score: 3',
      'Best: 5',
    ]);
    expect(ScoreText.gameOver(score: 6, highScore: 6, newBest: true), [
      'Score: 6',
      'Best: 6',
      'New best!',
    ]);
  });

  test('best shows the stored record, and rises past it during a run', () {
    expect(ScoreText.best(0, 0), 'Best: 0'); // fresh install
    expect(ScoreText.best(3, 10), 'Best: 10');
    expect(ScoreText.best(10, 10), 'Best: 10');
    expect(ScoreText.best(11, 10), 'Best: 11');
  });
}
