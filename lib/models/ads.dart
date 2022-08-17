class Ads {
  final String id;
  final String name;
  final String photoSid;

  final String description;
  final String url;

  Ads(this.id, this.name, this.photoSid, this.description, this.url);

  getPhotoUrl() =>
      // "${AppController.cc.endpoint.getPhotoSidPreviewPrefix()}$photoSid";
      photoSid;

  factory Ads.fromJson(Map<String, dynamic> json) {
    return Ads(json['id'].toString(), json['name'], json['photoSid'],
        json['description'], json['url'].toString());
  }
}
