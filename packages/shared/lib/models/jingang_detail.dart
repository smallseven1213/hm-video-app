class JinGangDetail {
  final int? id;
  final String name;
  final String photoSid;
  final String? url;
  final String? remark;

  JinGangDetail(
    this.id,
    this.name,
    this.photoSid, {
    this.url,
    this.remark,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['photoSid'] = photoSid;
    data['url'] = url;
    data['remark'] = remark;
    return data;
  }

  factory JinGangDetail.fromJson(Map<String, dynamic> json) {
    return JinGangDetail(
      json['id'],
      json['name'],
      json['photoSid'],
      url: json['url'],
    );
  }
}
