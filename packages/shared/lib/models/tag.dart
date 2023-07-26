import 'vod.dart';

class Tags {
  String? title;
  bool? outerFrame;
  List<Tag>? details;

  Tags({title, outerFrame, details});

  Tags.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    outerFrame = json['outerFrame'];
    if (json['details'] != null) {
      details = <Tag>[];
      json['details'].forEach((v) {
        details!.add(Tag.fromJson(v));
      });
    }
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

  Tag(
    this.id,
    this.name, {
    this.parent,
    this.orderIndex,
    this.photoSid,
    this.film,
  });

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      json['id'],
      json['name'],
      parent: json['parent'],
      orderIndex: json['orderIndex'],
      photoSid: json['photoSid'],
      film: json['film'],
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
