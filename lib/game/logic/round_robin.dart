/// Cycles through [count] slots in order, wrapping around. Used to rotate
/// sound-effect voices so overlapping plays do not cut each other off.
class RoundRobin {
  RoundRobin(this.count) : assert(count > 0);

  final int count;
  int _next = 0;

  /// The next slot index (0..count-1).
  int next() {
    final i = _next;
    _next = (_next + 1) % count;
    return i;
  }
}
