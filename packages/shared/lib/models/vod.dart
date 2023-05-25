import 'dart:math';
import 'package:shared/models/publisher.dart';
import 'package:shared/models/supplier.dart';
import 'package:shared/models/tag.dart';

import '../services/system_config.dart';
import 'actor.dart';

final systemConfig = SystemConfig();

enum VideoType {
  none,
  video,
  embeddedAd,
  areaAd,
}

class Vod {
  final int id;
  final String title;
  final int? subScript;
  int? timeLength;
  final String? coverVertical;
  final String? coverHorizontal;
  final String? videoUrlUd; // preview
  final String? videoUrlHd; // formal
  final String? videoUrlSd;
  String? videoUrl;

  final String? externalId;
  String? titleSub;
  String? description;
  final String? detail;
  int? film;
  int? currentNum;
  int? totalNum;
  int? belong;
  bool isAvailable;
  bool isCollect;
  final int? chargeType;
  final int? orderIndex;
  int? videoCollectTimes;
  int? videoViewTimes;
  List<Actor>? actors;
  List<Tag>? tags;
  final List<Tag>? internalTags;
  List<int>? internalTagIds;
  final dynamic region;
  Publisher? publisher;
  Supplier? supplier;
  String? point;
  double? buyPoint = 0;
  List<Vod>? belongVods;
  // 影片頁面用的廣告
  bool? isAd;
  String? videoAdUrl;
  String? adCover;
  String? adTitle;
  String? appIcon;
  String? adUrl;
  int? dataType;

  Vod(
    this.id,
    this.title, {
    this.subScript = 0,
    this.timeLength = 0,
    this.coverHorizontal = '',
    this.coverVertical = '',
    this.videoUrlUd = '',
    this.videoUrlHd = '',
    this.videoUrlSd = '',
    this.videoUrl = '',
    this.externalId = '',
    this.titleSub = '',
    this.description = '',
    this.detail = '',
    this.film = 0,
    this.currentNum = 0,
    this.totalNum = 0,
    this.belong = 0,
    this.isAvailable = false,
    this.isCollect = false,
    this.chargeType = 0,
    this.orderIndex = 0,
    this.actors,
    this.tags,
    this.internalTags,
    this.internalTagIds,
    this.region,
    this.publisher,
    this.supplier,
    this.belongVods,
    this.point,
    this.buyPoint,
    this.videoCollectTimes,
    this.videoViewTimes,
    this.isAd = false,
    this.videoAdUrl = '',
    this.adCover = '',
    this.adTitle = '',
    this.appIcon,
    this.adUrl = '',
    this.dataType,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subScript': subScript,
      'timeLength': timeLength,
      'coverVertical': coverVertical,
      'coverHorizontal': coverHorizontal,
      'videoUrlHd': videoUrlHd,
      'videoUrlSd': videoUrlSd,
      'videoUrlUd': videoUrlUd,
      'videoUrl': videoUrl,
      'externalId': externalId,
      'titleSub': titleSub,
      'description': description,
      'detail': detail,
      'film': film,
      'currentNum': currentNum,
      'totalNum': totalNum,
      'belong': belong,
      'isAvailable': isAvailable,
      'isCollect': isCollect,
      'chargeType': chargeType,
      'orderIndex': orderIndex,
      'actors': actors,
      'tags': tags,
      'internalTags': internalTags,
      'internalTagIds': internalTagIds,
      'region': region,
      'publisher': publisher,
      'supplier': supplier,
      'belongVods': belongVods,
      'point': point,
      'buyPoint': buyPoint,
      'videoCollectTimes': videoCollectTimes,
      'videoViewTimes': videoViewTimes,
      'isAd': isAd,
      'videoAdUrl': videoAdUrl,
      'adCover': adCover,
      'adTitle': adTitle,
      'appIcon': appIcon,
      'adUrl': adUrl,
      'dataType': dataType,
    };
  }

  factory Vod.fromJson(Map<String, dynamic> json) {
    try {
      return Vod(
        json['id'] ?? 0,
        json['title'] ?? '',
        subScript: json['subScript'] ?? 0,
        timeLength: json['timeLength'] ?? 0,
        coverVertical: json['coverVertical'] ?? '',
        coverHorizontal: json['coverHorizontal'] ?? '',
        videoUrl: json['videoUrl'] ?? '',
        externalId: json['externalId'] ?? '',
        titleSub: json['titleSub'] ?? '',
        description: json['description'] ?? '',
        detail: json['detail'] ?? '',
        film: json['film'] ?? 0,
        currentNum: json['currentNum'] ?? 0,
        totalNum: json['totalNum'] ?? 0,
        belong: json['belong'] ?? 0,
        isAvailable: json['isPreview'] ?? false,
        isCollect: json['isCollected'] ?? false,
        chargeType: json['chargeType'] ?? 0,
        orderIndex: json['orderIndex'] ?? 0,
        point: json['point'] == null ? '0' : json['point'].toString(),
        buyPoint: json['buyPoints'] == null
            ? null
            : double.parse(json['buyPoints'].toString()),
        videoCollectTimes: json['videoCollectTimes'] == null
            ? 0
            : int.parse(json['videoCollectTimes'].toString()),
        videoViewTimes: json['videoViewTimes'] == null
            ? 0
            : int.parse(json['videoViewTimes'].toString()),
        actors: (json['actor'] ?? json['actors']) == null
            ? []
            : List.from(
                ((json['actor'] ?? json['actors']) as List<dynamic>).map((e) {
                if (e is int) {
                  return Actor(e, '', '');
                }
                return Actor.fromJson(e);
              })),
        tags: (json['tag'] ?? json['tags']) == null
            ? []
            : List.from(
                ((json['tag'] ?? json['tags']) as List<dynamic>).map((e) {
                if (e is int) {
                  return Tag(e, '');
                }
                return Tag.fromJson(e);
              })),
        internalTagIds: (json['internalTag'] ?? json['internalTags']) == null
            ? []
            : List.from(
                (json['internalTag'] ?? json['internalTags']) as List<dynamic>),
        region: json['region'],
        publisher: (json['publisher'] == null)
            ? null
            : Publisher.fromJson(json['publisher']),
        supplier: (json['supplier'] == null)
            ? null
            : Supplier.fromJson(json['supplier']),
        belongVods: json['belongVods'] == null
            ? null
            : List.from((json['belongVods'] as List<dynamic>)
                .map((e) => Vod.fromJson(e))),
        // 廣告用
        appIcon: json['appIcon'],
        adUrl: json['adUrl'],
        dataType: json['dataType'],
      );
    } catch (e) {
      logger.i('json: $e');
      return Vod(0, '');
    }
  }

  Vod fillDetail(Map<String, dynamic> json) {
    titleSub = json['titleSub'];
    description = json['description'];
    film = json['film'];
    currentNum = json['currentNum'];
    totalNum = json['totalNum'];
    belong = json['belong'];
    timeLength = json['timeLength'];
    videoCollectTimes = int.parse(json['videoCollectTimes'].toString());
    videoViewTimes = int.parse(json['videoViewTimes'].toString());
    actors = (json['actor'] ?? json['actors']) == null
        ? []
        : List.from(
            ((json['actor'] ?? json['actors']) as List<dynamic>).map((e) {
            if (e is int) {
              return Actor(e, '', '');
            }
            return Actor.fromJson(e);
          }));
    tags = (json['tag'] ?? json['tags']) == null
        ? []
        : List.from(((json['tag'] ?? json['tags']) as List<dynamic>).map((e) {
            if (e is int) {
              return Tag(e, '');
            }
            return Tag.fromJson(e);
          }));
    internalTagIds = (json['internalTag'] ?? json['internalTags']) == null
        ? []
        : List.from(
            (json['internalTag'] ?? json['internalTags']) as List<dynamic>);
    publisher = (json['publisher'] == null)
        ? null
        : Publisher.fromJson(json['publisher']);
    belongVods = json['belongVods'] == null
        ? null
        : List.from(
            (json['belongVods'] as List<dynamic>).map((e) => Vod.fromJson(e)));
    return this;
  }

  String? getVideoUrl() {
    if (videoUrl != null && videoUrl!.isNotEmpty) {
      // logger.i(videoUrlUd);
      String uri = videoUrl!.replaceAll('\\', '/').replaceAll('//', '/');
      // logger.i(uri);
      if (uri.startsWith('http')) {
        return uri;
      }
      String id = uri.substring(uri.indexOf('/') + 1);
      return '${systemConfig.vodHost}/$id/$id.m3u8';
    }
    return null;
  }
}
