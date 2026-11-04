import '../../core/game_config.dart';

class SmokePuff {
  SmokePuff(this.x, this.y);
  double x;
  final double y;
  double age = 0;

  double get progress => age / GameConfig.smokeLifetime;
}

/// Lifecycle of the plane's smoke trail: spawn at a steady rate, drift left
/// with the world, expire after the configured lifetime. Cosmetic only.
class SmokePuffs {
  final List<SmokePuff> puffs = [];
  double _sinceSpawn = 0;

  void step(
    double dt, {
    required double spawnX,
    required double spawnY,
    double speed = GameConfig.scrollSpeed,
  }) {
    _sinceSpawn += dt;
    while (_sinceSpawn >= GameConfig.smokeSpawnInterval) {
      _sinceSpawn -= GameConfig.smokeSpawnInterval;
      puffs.add(SmokePuff(spawnX, spawnY));
    }
    for (final p in puffs) {
      p.age += dt;
      p.x -= speed * dt;
    }
    puffs.removeWhere((p) => p.age >= GameConfig.smokeLifetime);
  }

  void clear() {
    puffs.clear();
    _sinceSpawn = 0;
  }
}
