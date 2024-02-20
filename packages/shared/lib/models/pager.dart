class Pager<T> {
  final int total;
  final int current;
  final int limit;
  final List<T> data;

  Pager({
    required this.total,
    required this.current,
    required this.limit,
    required this.data,
  });

  factory Pager.fromJson(Map<String, dynamic> json, List<T> data) {
    return Pager(
        total: json['total'],
        current: json['current'],
        limit: json['limit'],
        data: data);
  }
}
