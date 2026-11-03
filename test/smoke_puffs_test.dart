import 'package:flutter_test/flutter_test.dart';
import 'package:fright_flight/core/game_config.dart';
import 'package:fright_flight/game/logic/smoke_puffs.dart';

void main() {
  void run(SmokePuffs s, double seconds) {
    const dt = 0.01;
    for (var t = 0.0; t < seconds; t += dt) {
      s.step(dt, spawnX: 150, spawnY: 100);
    }
  }

  test('spawns puffs at a steady rate', () {
    final s = SmokePuffs();
    run(s, 0.3);
    expect(s.puffs.length, closeTo(0.3 / GameConfig.smokeSpawnInterval, 1));
  });

  test('puffs drift left and expire', () {
    final s = SmokePuffs();
    run(s, 0.2);
    expect(s.puffs.first.x, lessThan(150));
    run(s, GameConfig.smokeLifetime * 3);
    final max = GameConfig.smokeLifetime / GameConfig.smokeSpawnInterval + 2;
    expect(s.puffs.length, lessThanOrEqualTo(max));
    expect(s.puffs.every((p) => p.progress < 1), isTrue);
  });

  test('clear removes all puffs', () {
    final s = SmokePuffs();
    run(s, 0.3);
    s.clear();
    expect(s.puffs, isEmpty);
  });
}
