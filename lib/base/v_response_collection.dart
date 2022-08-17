import 'dart:math' as math;

class VCollection<T> {
  final List<T> rows;
  final int total;
  VCollection(this.total, this.rows);

  Future<List<T>> getManyBy({
    int offsetPos = 1,
    required int limit,
    Duration delay = const Duration(milliseconds: 666),
  }) async {
    int start = math.max(0, (offsetPos - 1)) * limit;
    int end = math.min(rows.length, start + limit);
    await Future.delayed(delay);
    return rows.getRange(start, end).toList();
  }
}
