import 'package:flutter_test/flutter_test.dart';
import 'package:fright_flight/game/logic/round_robin.dart';

void main() {
  test('cycles through slots and wraps around', () {
    final r = RoundRobin(3);
    expect([for (var i = 0; i < 7; i++) r.next()], [0, 1, 2, 0, 1, 2, 0]);
  });

  test('a single slot always returns 0', () {
    final r = RoundRobin(1);
    expect([r.next(), r.next(), r.next()], [0, 0, 0]);
  });
}
