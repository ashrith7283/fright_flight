import 'package:flutter_test/flutter_test.dart';
import 'package:fright_flight/game/logic/score_text.dart';

void main() {
  test('playing text is the score', () {
    expect(ScoreText.playing(12), '12');
  });

  test('best shows the stored record, and rises past it during a run', () {
    expect(ScoreText.best(0, 0), 'Best: 0'); // fresh install
    expect(ScoreText.best(3, 10), 'Best: 10');
    expect(ScoreText.best(10, 10), 'Best: 10');
    expect(ScoreText.best(11, 10), 'Best: 11');
  });
}
