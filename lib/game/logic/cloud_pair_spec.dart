import '../../core/game_config.dart';

/// A top and bottom cloud with a gap between them.
class CloudPairSpec {
  CloudPairSpec({required this.x, required this.gapCentre});

  /// Left edge of the pair.
  double x;
  final double gapCentre;

  double get gapTop => gapCentre - GameConfig.gapSize / 2;
  double get gapBottom => gapCentre + GameConfig.gapSize / 2;
  double get right => x + GameConfig.cloudWidth;
}
