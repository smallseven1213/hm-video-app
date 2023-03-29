import 'package:shared/models/video.dart';

class Tag {
  final int id;
  final String name;
  final int? parent;
  final int? orderIndex;

  Tag(this.id, this.name, {this.parent, this.orderIndex});

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      json['id'],
      json['name'],
      parent: json['parent'],
      orderIndex: json['orderIndex'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['parent'] = parent;
    data['orderIndex'] = orderIndex;
    return data;
  }
}

class TagVideos {
  final int id;
  final String? name;
  List<Video>? videos;

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
          (json['videos'] as List<dynamic>).map((e) => Video.fromJson(e))),
    );
  }
}
