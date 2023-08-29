class HMApiResponsePaginationData<T> {
  String? current;
  T? data;
  String? limit;
  int? total;

  HMApiResponsePaginationData(
      {this.current, this.data, this.limit, this.total});

  HMApiResponsePaginationData.fromJson(Map<String, dynamic> json) {
    current = json['current'];
    data = json['data'];
    limit = json['limit'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current'] = current;
    data['data'] = data;
    data['limit'] = limit;
    data['total'] = total;
    return data;
  }
}
