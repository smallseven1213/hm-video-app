import 'vod.dart';

class Tags {
  String? title;
  bool? outerFrame;
  List<Tag>? details;
  int? shortVideoTotal;

  Tags({
    title,
    outerFrame,
    details,
    this.shortVideoTotal,
  });

  Tags.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    outerFrame = json['outerFrame'];
    if (json['details'] != null) {
      details = <Tag>[];
      json['details'].forEach((v) {
        details!.add(Tag.fromJson(v));
      });
    }
    shortVideoTotal = json['shortVideoTotal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['outerFrame'] = outerFrame;
    data['details'] = details;
    return data;
  }
}

class Tag {
  final int id;
  final String name;
  final int? parent;
  final int? orderIndex;
  final String? photoSid;
  final int? film;
  final String? coverVertical;
  final String? title;
  final bool? isFollow;

  Tag(this.id, this.name,
      {this.parent,
      this.orderIndex,
      this.photoSid,
      this.film,
      this.coverVertical,
      this.title,
      this.isFollow});

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      json['id'],
      json['name'],
      parent: json['parent'],
      orderIndex: json['orderIndex'],
      photoSid: json['photoSid'],
      film: json['film'],
      coverVertical: json['coverVertical'],
      title: json['title'],
      isFollow: json['isFollow'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['parent'] = parent;
    data['orderIndex'] = orderIndex;
    data['photoSid'] = photoSid;
    data['film'] = film;
    data['coverVertical'] = coverVertical;
    data['title'] = title;
    data['isFollow'] = isFollow;
    return data;
  }
}

class TagVideos {
  final int id;
  final String? name;
  List<Vod>? videos;

  TagVideos(
    this.id, {
    this.name,
    this.videos,
  });

  factory TagVideos.fromJson(Map<String, dynamic> json) {
    return TagVideos(
      json['id'],
      name: json['name'],
      videos: List.from(
          (json['videos'] as List<dynamic>).map((e) => Vod.fromJson(e))),
    );
  }
}
