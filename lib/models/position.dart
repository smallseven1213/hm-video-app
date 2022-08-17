class Position {
  final int id;
  final String photoSid;
  final String? url;

  Position(
    this.id,
    this.photoSid,
    this.url,
  );

  getPhotoUrl() =>
      // "${AppController.cc.endpoint.getPhotoSidPreviewPrefix()}$photoSid";
      photoSid;

  factory Position.fromJson(Map<String, dynamic> json) {
    return Position(
      json['id'],
      json['photoSid'],
      json['url'],
    );
  }
}
