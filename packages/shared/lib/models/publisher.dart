class Publisher {
  final int id;
  final String name;
  final String photoSid;
  final String? aliasName;
  final int? orderIndex;
  final int? containVideos;

  Publisher(
    this.id,
    this.name,
    this.photoSid, {
    this.aliasName,
    this.orderIndex,
    this.containVideos,
  });
  getPhotoUrl() =>
      // "${AppController.cc.endpoint.getPhotoSidPreviewPrefix()}$photoSid";
      photoSid;

  factory Publisher.fromJson(Map<String, dynamic> json) {
    return Publisher(
      json['id'] ?? 0,
      json['name'] ?? '',
      json['photoSid'] ?? '',
      aliasName: json['aliasName'],
      orderIndex: json['orderIndex'],
      containVideos: json['containVideos'],
    );
  }
}
