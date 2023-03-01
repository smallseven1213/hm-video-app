class Banner {
  final int id;
  final String photoSid;
  final String? url;

  Banner(
    this.id,
    this.photoSid,
    this.url,
  );

  getPhotoUrl() =>
      // "${AppController.cc.endpoint.getPhotoSidPreviewPrefix()}$photoSid";
      photoSid;

  factory Banner.fromJson(Map<String, dynamic> json) {
    return Banner(
      json['id'],
      json['photoSid'],
      json['url'],
    );
  }
}
