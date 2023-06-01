import 'package:shared/models/supplier.dart';
import 'package:shared/models/videos_tag.dart';

class ShortVideoDetail {
  final int id;
  final List<VideoTag> tag;
  final Supplier? supplier;
  final int? videoCollectTimes;
  final int? collects;
  final int favorites;

  ShortVideoDetail(this.id, this.tag, this.supplier, this.videoCollectTimes,
      this.collects, this.favorites);

  factory ShortVideoDetail.fromJson(Map<String, dynamic> json) {
    return ShortVideoDetail(
        json['id'],
        List.from(
            (json['tag'] as List<dynamic>).map((e) => VideoTag.fromJson(e))),
        json['supplier'] != null ? Supplier.fromJson(json['supplier']) : null,
        json['videoCollectTimes'] as int?,
        json['collects'] as int?,
        json['favorites']);
  }

  // toJson function
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (tag != null) {
      data['tag'] = tag.map((e) => e.toJson()).toList();
    }
    if (supplier != null) {
      data['supplier'] = supplier!.toJson();
    }
    data['videoCollectTimes'] = videoCollectTimes ?? '';
    data['collects'] = collects ?? '';
    data['favorites'] = favorites;
    return data;
  }
}
