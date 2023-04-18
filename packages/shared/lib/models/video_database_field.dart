import 'package:shared/models/tag.dart';

// import 'channel_info.dart';

class VideoDatabaseField {
  final int id;
  final String coverVertical;
  final String coverHorizontal;
  final int timeLength;
  final List<Tag> tags;
  final String title;
  final int videoViewTimes;
  // final Data? detail;
  VideoDatabaseField({
    required this.id,
    required this.coverVertical,
    required this.coverHorizontal,
    required this.timeLength,
    required this.tags,
    required this.title,
    required this.videoViewTimes,
    // this.detail,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'coverVertical': coverVertical,
      'coverHorizontal': coverHorizontal,
      'timeLength': timeLength,
      'tags': tags,
      'title': title,
      'videoViewTimes': videoViewTimes,
      // 'detail': detail,
    };
  }

  factory VideoDatabaseField.fromJson(Map<String, dynamic> json) {
    return VideoDatabaseField(
      id: json['id'],
      coverVertical: json['coverVertical'],
      coverHorizontal: json['coverHorizontal'],
      timeLength: json['timeLength'],
      tags: (json['tags'] as List<dynamic>)
          .map<Tag>((tagJson) => Tag.fromJson(tagJson as Map<String, dynamic>))
          .toList(),
      title: json['title'],
      videoViewTimes: json['videoViewTimes'],
      // detail: json['detail'],
    );
  }
}
