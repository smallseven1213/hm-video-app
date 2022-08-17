import 'package:wgp_video_h5app/models/video.dart';

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
}

class TagVideos {
  final int id;
  final String? name;
  List<Video>? videos;

  TagVideos(
      this.id,
      {
        this.name,
        this.videos,
      });

  factory TagVideos.fromJson(Map<String, dynamic> json) {
    return TagVideos(
      json['id'],
      name: json['name'],
      videos :  List.from((json['videos']  as List<dynamic>).map((e) => Video.fromJson(e))),
    );
  }
}