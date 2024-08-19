import 'post.dart';
import 'tag.dart';

class PostDetail {
  final Post post;
  final List<Series> series;
  final List<Recommend> recommend;

  PostDetail({
    required this.post,
    required this.series,
    required this.recommend,
  });

  factory PostDetail.fromJson(Map<String, dynamic> json) {
    try {
      return PostDetail(
        post: Post.fromJson(json['post']),
        series: json['series'] != null
            ? List<Series>.from((json['series'] as List<dynamic>)
                .map((e) => Series.fromJson(e)))
            : [],
        recommend: json['recommend'] != null
            ? List<Recommend>.from((json['recommend'] as List<dynamic>)
                .map((e) => Recommend.fromJson(e)))
            : [],
      );
    } catch (e) {
      // Handle the exception here
      print('Error parsing PostDetail from JSON: $e');
      throw e;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['post'] = post.toJson();
    data['series'] =
        series.isNotEmpty ? series.map((e) => e.toJson()).toList() : [];
    data['recommend'] =
        recommend.isNotEmpty ? recommend.map((e) => e.toJson()).toList() : [];
    return data;
  }
}

class Series {
  final int id;
  final String title;
  final String cover;
  final int currentChapter;

  Series({
    required this.id,
    required this.title,
    required this.cover,
    this.currentChapter = 0,
  });

  factory Series.fromJson(Map<String, dynamic> json) {
    return Series(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      cover: json['cover'] ?? '',
      currentChapter: json['currentChapter'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'cover': cover,
      'currentChapter': currentChapter,
    };
  }
}

class Recommend {
  final int id;
  final String title;
  final String cover;
  final int likeCount;
  final int viewCount;
  final List<Tag> tags;

  Recommend({
    required this.id,
    required this.title,
    required this.cover,
    required this.likeCount,
    required this.viewCount,
    required this.tags,
  });

  factory Recommend.fromJson(Map<String, dynamic> json) {
    return Recommend(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      cover: json['cover'] ?? '',
      likeCount: json['likeCount'] ?? 0,
      viewCount: json['viewCount'] ?? 0,
      tags: json['tags'] != null
          ? (json['tags'] as List<dynamic>).map((e) => Tag.fromJson(e)).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'cover': cover,
      'likeCount': likeCount,
      'viewCount': viewCount,
      'tags': tags.isNotEmpty ? tags.map((e) => e.toJson()).toList() : [],
    };
  }
}
