class HMApiResponseBaseWithDataWithData<T> {
  String? code;
  T? data;
  String? message;

  HMApiResponseBaseWithDataWithData({
    this.code,
    this.data,
    this.message,
  });

  HMApiResponseBaseWithDataWithData.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    data = json['data'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['data'] = data;
    data['message'] = message;
    return data;
  }
}
