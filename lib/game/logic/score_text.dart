/// Plain-text content for the score display.
class ScoreText {
  const ScoreText._();

  static String playing(int score) => '$score';

  static List<String> gameOver({
    required int score,
    required int highScore,
    required bool newBest,
  }) => ['Score: $score', 'Best: $highScore', if (newBest) 'New best!'];
}
