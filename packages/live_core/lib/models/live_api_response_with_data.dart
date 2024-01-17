class LiveApiResponseBaseWithDataWithData<T> {
  int? code;
  T? data;

  LiveApiResponseBaseWithDataWithData({this.code, this.data});

  LiveApiResponseBaseWithDataWithData.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['data'] = data;
    return data;
  }
}
