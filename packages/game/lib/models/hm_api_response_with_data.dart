class HMApiResponseBaseWithDataWithData<T> {
  String? code;
  T? data;

  HMApiResponseBaseWithDataWithData({this.code, this.data});

  HMApiResponseBaseWithDataWithData.fromJson(Map<String, dynamic> json) {
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
