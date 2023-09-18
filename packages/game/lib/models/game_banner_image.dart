class GameBannerImage {
  String? photoId;
  String? photoUrl;
  String? url;

  GameBannerImage({photoId, photoUrl, url});

  GameBannerImage.fromJson(Map<String, dynamic> json) {
    photoId = json['photoId'] ?? '';
    photoUrl = json['photoUrl'] ?? '';
    url = json['url'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['photoId'] = photoId;
    data['photoUrl'] = photoUrl;
    data['url'] = url;
    return data;
  }
}
