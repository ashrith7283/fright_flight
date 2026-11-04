/// Plain-text content for the score display.
class ScoreText {
  const ScoreText._();

  static String playing(int score) => '$score';

  /// Best score for the game window; never lower than the live score, so it
  /// rises as the player passes the stored record.
  static String best(int score, int highScore) =>
      'Best: ${score > highScore ? score : highScore}';

  static List<String> gameOver({
    required int score,
    required int highScore,
    required bool newBest,
  }) => ['Score: $score', 'Best: $highScore', if (newBest) 'New best!'];
}
