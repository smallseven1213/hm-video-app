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
      shortVideoTotal: json['shortVideoTotal'],
      videos: List.from(
          (json['videos'] as List<dynamic>).map((e) => VideoTag.fromJson(e))),
    );
  }
}

class VideoTag1 {
  final int id;
  final String? coverVertical;
  final String? title;
  final String? name;
  final bool? isFollow;
  final int? collects;
  final int? views;

  VideoTag1(this.id,
      {this.coverVertical,
      this.title,
      this.name,
      this.isFollow,
      this.collects,
      this.views});

  factory VideoTag1.fromJson(Map<String, dynamic> json) {
    return VideoTag1(
      json['id'],
      coverVertical: json['coverVertical'],
      title: json['title'],
      name: json['name'],
      isFollow: json['isFollow'],
      collects: json['collects'],
      views: json['views'],
    );
  }
}
