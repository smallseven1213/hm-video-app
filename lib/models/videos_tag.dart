import 'package:wgp_video_h5app/models/index.dart';

class VideoTag {
  final int id;
  final String? coverVertical;
  final String? title;
  final String? name;
  final bool? isFollow;

  VideoTag(this.id, {this.coverVertical, this.title, this.name, this.isFollow});

  factory VideoTag.fromJson(Map<String, dynamic> json) {
    return VideoTag(
      json['id'],
      coverVertical: json['coverVertical'],
      title: json['title'],
      name: json['name'],
      isFollow: json['isFollow'],
    );
  }
}


class VideoTags {
  int id;
  String name;
  int? shortVideoTotal;
  List<VideoTag>? videos;

  VideoTags(this.id, this.name, {this.shortVideoTotal, this.videos});

  factory VideoTags.fromJson(Map<String, dynamic> json) {
    return VideoTags(
      json['id'],
      json['name'],
      shortVideoTotal : json['shortVideoTotal'],
      videos : List.from((json['videos']  as List<dynamic>).map((e) => VideoTag.fromJson(e))),
    );
  }
}
