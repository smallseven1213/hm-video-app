class LiveApiResponseBase<T> {
  final int code;
  final T data;
  final String msg;

  LiveApiResponseBase(
      {required this.code, required this.data, required this.msg});

  factory LiveApiResponseBase.fromJson(
      Map<String, dynamic> json, T Function(Object?) fromJsonT) {
    return LiveApiResponseBase(
      code: json['code'],
      data: fromJsonT(json['data']),
      msg: json['msg'],
    );
  }
}
