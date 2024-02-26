class LiveApiResponseList<T> {
  final List<T> items;
  final Pagination pagination;

  LiveApiResponseList({required this.items, required this.pagination});

  factory LiveApiResponseList.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    List<T> items = (json["data"]["list"]["items"] as List)
        .map((item) => fromJsonT(item))
        .toList();

    Pagination pagination = Pagination.fromJson(json["data"]["list"]["meta"]);

    return LiveApiResponseList(items: items, pagination: pagination);
  }
}

class Pagination {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  Pagination({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json["current_page"],
      lastPage: json["last_page"],
      perPage: json["per_page"],
      total: json["total"],
    );
  }
}
