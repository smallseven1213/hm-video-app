class BannerPhoto {
  final int id;
  final String photoSid;
  final bool isAutoClose;
  final int? positionId;
  final String? logoSid;
  final String? url;
  final String? name;
  final String? title;
  final List? tags;
  final String? button;

  BannerPhoto({
    this.id = 0,
    this.isAutoClose = false,
    this.logoSid,
    this.name,
    this.photoSid = '',
    this.title,
    this.url,
    this.tags,
    this.button,
    this.positionId,
  });
  factory BannerPhoto.fromJson(Map<String, dynamic> json) {
    return BannerPhoto(
      id: json['id'],
      isAutoClose: json['isAutoClose'] ?? false,
      photoSid: json['photoSid'],
      logoSid: json['logoSid'],
      url: json['url'],
      name: json['name'],
      title: json['title'],
      button: json['button'],
      tags: json['tags'],
      positionId: json['positionId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'isAutoClose': isAutoClose,
      'photoSid': photoSid,
      'logoSid': logoSid,
      'url': url,
      'name': name,
      'title': title,
      'button': button,
      'tags': tags,
      'positionId': positionId,
    };
  }
}
