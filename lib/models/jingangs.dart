class JinGang {
  final int id;
  final String name;
  final String photoSid;
  final String? url;
  final String? remark;

  JinGang(
    this.id,
    this.name,
    this.photoSid, {
    this.url,
    this.remark,
  });
  getPhotoUrl() =>
      // "${AppController.cc.endpoint.getPhotoSidPreviewPrefix()}$photoSid";
      photoSid;

  factory JinGang.fromJson(Map<String, dynamic> json) {
    return JinGang(
      json['id'],
      json['name'],
      json['photoSid'],
      url: json['url'],
    );
  }
}
