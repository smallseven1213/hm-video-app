import 'package:shared/models/tag.dart';

import 'channel_info.dart';

class VideoDatabaseField {
  final int id;
  final String coverVertical;
  final String coverHorizontal;
  final int timeLength;
  final List<Tag> tags;
  final String title;
  final int videoViewTimes;
  final double? imageRatio;
  final Data? detail;
  final bool isEmbeddedAds;
  final bool isEditing;
  VideoDatabaseField({
    required this.id,
    required this.coverVertical,
    required this.coverHorizontal,
    required this.timeLength,
    required this.tags,
    required this.title,
    required this.videoViewTimes,
    this.isEmbeddedAds = false,
    this.detail,
    this.isEditing = false,
    this.imageRatio,
  });
}
