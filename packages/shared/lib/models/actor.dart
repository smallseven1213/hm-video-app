import 'package:logger/logger.dart';

final logger = Logger();

class Actor {
  final int id;
  final String name;
  final String? aliasName;
  final String photoSid;
  final String? description;
  final String? detail;
  final int? orderIndex;
  final int? containVideos;
  final int? collectTimes;
  int? actorCollectTimes;
  final bool? isCollect;
  final String? coverVertical;
  final int? regionId;

  Actor(
    this.id,
    this.name,
    this.photoSid, {
    this.aliasName,
    this.description,
    this.detail,
    this.orderIndex,
    this.containVideos,
    this.collectTimes,
    this.actorCollectTimes,
    this.isCollect,
    this.coverVertical,
    this.regionId,
  });
  getPhotoUrl() =>
      // "${AppController.cc.endpoint.getPhotoSidPreviewPrefix()}$photoSid";
      photoSid;

  factory Actor.fromJson(Map<String, dynamic> json) {
    if (json['actorCollectTimes'] != null &&
        json['actorCollectTimes'].runtimeType == String) {
      json['actorCollectTimes'] = int.parse(json['actorCollectTimes']);
    }
    return Actor(
      json['id'] ?? 0,
      json['name'] ?? '',
      json['photoSid'] ?? '',
      aliasName: json['aliasName'] ?? '',
      description: json['description'] ?? '',
      detail: json['detail'] ?? '',
      orderIndex: json['orderIndex'] ?? 0,
      containVideos: json['containVideos'] ?? 0,
      collectTimes: json['collectTimes'] ?? 0,
      actorCollectTimes: json['actorCollectTimes'] ?? 0,
      isCollect: json['isCollect'] ?? false,
      coverVertical: json['coverVertical'] ?? '',
      regionId: json['regionId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'photoSid': photoSid,
      'aliasName': aliasName,
      'description': description,
      'detail': detail,
      'orderIndex': orderIndex,
      'containVideos': containVideos,
      'collectTimes': collectTimes,
      'actorCollectTimes': actorCollectTimes,
      'isCollect': isCollect,
      'coverVertical': coverVertical,
      'regionId': regionId,
    };
  }
}
