import 'package:shared/models/video.dart';

class Supplier {
  final int id;
  final String? account;
  final String? remark;
  final String? aliasName;
  final int? containVideos;
  final String? coverVertical;
  final String? title;
  final int? shortVideoTotal;
  final int? followTotal;
  final int? collectTotal;
  late bool? isFollow;
  final String? videoViewTimes;
  final String? videoCollectTimes;
  final String? photoSid;

  Supplier(
    this.id,
    this.account, {
    this.remark,
    this.aliasName,
    this.containVideos,
    this.coverVertical,
    this.title,
    this.shortVideoTotal,
    this.followTotal,
    this.collectTotal,
    this.isFollow,
    this.videoViewTimes,
    this.videoCollectTimes,
    this.photoSid,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      json['id'],
      json['name'],
      aliasName: json['aliasName'],
      containVideos: json['containVideos'],
      coverVertical: json['coverVertical'],
      title: json['title'],
      shortVideoTotal: json['shortVideoTotal'],
      followTotal: json['followTotal'],
      collectTotal: json['collectTotal'],
      isFollow: json['isFollow'],
      videoViewTimes: json['videoViewTimes'],
      videoCollectTimes: json['videoCollectTimes'],
      photoSid: json['photoSid'],
    );
  }
}

class SupplierTag {
  final int tagId;
  final String? tagName;
  final int? shortVideoTotal;
  late int? followTotal;
  late bool? isFollow;

  SupplierTag(
    this.tagId, {
    this.tagName,
    this.shortVideoTotal,
    this.followTotal,
    this.isFollow,
  });

  factory SupplierTag.fromJson(Map<String, dynamic> json) {
    return SupplierTag(
      json['tagId'],
      tagName: json['tagName'],
      shortVideoTotal: json['shortVideoTotal'],
      followTotal: json['followTotal'],
      isFollow: json['isFollow'],
    );
  }
}

class SupplierVideos {
  final int id;
  final String? aliasName;
  List<Video>? videos;

  SupplierVideos(
    this.id, {
    this.aliasName,
    this.videos,
  });

  factory SupplierVideos.fromJson(Map<String, dynamic> json) {
    return SupplierVideos(
      json['id'],
      aliasName: json['aliasName'],
      videos: List.from(
          (json['videos'] as List<dynamic>).map((e) => Video.fromJson(e))),
    );
  }
}

class SupplierMostLike {
  final int id;
  final String? photoSid;
  final String? aliasName;
  late bool? isFollow;
  final int? totalCollectStatistic;
  final int? totalFollowStatistic;

  SupplierMostLike(
    this.id, {
    this.photoSid,
    this.aliasName,
    this.isFollow,
    this.totalCollectStatistic,
    this.totalFollowStatistic,
  });

  factory SupplierMostLike.fromJson(Map<String, dynamic> json) {
    return SupplierMostLike(
      json['id'],
      photoSid: json['photoSid'],
      aliasName: json['aliasName'],
      isFollow: json['isFollow'],
      totalCollectStatistic: json['totalCollectStatistic'],
      totalFollowStatistic: json['totalFollowStatistic'],
    );
  }
}
