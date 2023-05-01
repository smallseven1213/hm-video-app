class BannerImage {
  int? id;
  String? photoSid;
  String? url;
  bool? isAutoClose;

  BannerImage({id, photoSid, url, isAutoClose});

  BannerImage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    photoSid = json['photoSid'];
    url = json['url'];
    isAutoClose = json['isAutoClose'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['photoSid'] = photoSid;
    data['url'] = url;
    data['isAutoClose'] = isAutoClose;
    return data;
  }
}
