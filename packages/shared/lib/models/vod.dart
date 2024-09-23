import 'package:get/get.dart';
import 'package:shared/controllers/system_config_controller.dart';
import 'package:shared/models/publisher.dart';
import 'package:shared/models/supplier.dart';
import 'package:shared/models/tag.dart';

import 'actor.dart';

enum VideoType {
  none,
  video,
  embeddedAd,
  areaAd,
  game,
}

class Vod {
  final int id;
  final String title;
  final double? aspectRatio;
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
  int? videoFavoriteTimes;
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
// 遊戲
  final String gameId;
  final String gameUrl;
  final String verticalLogo;
  final String horizontalLogo;
  final String jackpot;
  final int multiple;
  final String name;

  Vod(
    this.id,
    this.title, {
    this.aspectRatio = 0.00,
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
    this.videoFavoriteTimes,
    this.videoViewTimes,
    this.isAd = false,
    this.videoAdUrl = '',
    this.adCover = '',
    this.adTitle = '',
    this.appIcon,
    this.adUrl = '',
    this.dataType,
    this.gameId = '', // 默认值
    this.gameUrl = '', // 默认值
    this.verticalLogo = '', // 默认值
    this.horizontalLogo = '', // 默认值
    this.jackpot = '', // 默认值
    this.multiple = 0, // 默认值
    this.name = '', // 默认值
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
      'videoFavoriteTimes': videoFavoriteTimes,
      'videoViewTimes': videoViewTimes,
      'isAd': isAd,
      'videoAdUrl': videoAdUrl,
      'adCover': adCover,
      'adTitle': adTitle,
      'appIcon': appIcon,
      'adUrl': adUrl,
      'dataType': dataType,
      'gameId': gameId,
      'gameUrl': gameUrl, // 默认值
      'verticalLogo': verticalLogo, // 默认值
      'horizontalLogo': horizontalLogo, // 默认值
      'jackpot': jackpot, // 默认值
      'multiple': multiple, // 默认值
      'name': name,
    };
  }

  factory Vod.fromJson(Map<String, dynamic> json) {
    try {
      return Vod(
        json['id'] ?? 0,
        json['title'] ?? '',
        aspectRatio: json['aspectRatio'] != null
            ? double.tryParse(json['aspectRatio'].toString()) ?? 0.0
            : 0.0,
        subScript: json['subScript'] ?? 0,
        timeLength: json['timeLength'] ?? 0,
        coverVertical: json['coverVertical']?.toString() ?? '',
        coverHorizontal: json['coverHorizontal']?.toString() ?? '',
        videoUrl: json['videoUrl']?.toString() ?? '',
        externalId: json['externalId']?.toString() ?? '',
        titleSub: json['titleSub']?.toString() ?? '',
        description: json['description']?.toString() ?? '',
        detail: json['detail']?.toString() ?? '',
        film: json['film'] ?? 0,
        currentNum: json['currentNum'] ?? 0,
        totalNum: json['totalNum'] ?? 0,
        belong: json['belong'] ?? 0,
        isAvailable: json['isPreview'] ?? false,
        isCollect: json['isCollected'] ?? false,
        chargeType: json['chargeType'] ?? 0,
        orderIndex: json['orderIndex'] ?? 0,
        point: json['point']?.toString() ?? '0',
        buyPoint: json['buyPoints'] != null
            ? double.tryParse(json['buyPoints'].toString()) ?? 0.0
            : 0.0,
        videoCollectTimes: json['videoCollectTimes'] != null
            ? int.tryParse(json['videoCollectTimes'].toString()) ?? 0
            : 0,
        videoFavoriteTimes: json['videoFavoriteTimes'] != null
            ? int.tryParse(json['videoFavoriteTimes'].toString()) ?? 0
            : 0,
        videoViewTimes: json['videoViewTimes'] != null
            ? int.tryParse(json['videoViewTimes'].toString()) ?? 0
            : 0,
        actors: _parseActors(json['actor'] ?? json['actors']),
        tags: _parseTags(json['tag'] ?? json['tags']),
        internalTagIds:
            _parseInternalTags(json['internalTag'] ?? json['internalTags']),
        region: json['region'],
        publisher: json['publisher'] != null
            ? Publisher.fromJson(json['publisher'])
            : null,
        supplier: json['supplier'] != null
            ? Supplier.fromJson(json['supplier'])
            : null,
        belongVods: json['belongVods'] != null
            ? List.from((json['belongVods'] as List<dynamic>)
                .map((e) => Vod.fromJson(e)))
            : null,
        // Ad-related properties
        appIcon: json['appIcon']?.toString(),
        adUrl: json['adUrl']?.toString(),
        dataType: json['dataType'],
        isAd: json['isAd'] ?? false,
        videoAdUrl: json['videoAdUrl']?.toString() ?? '',
        adCover: json['adCover']?.toString() ?? '',
        adTitle: json['adTitle']?.toString() ?? '',
        // Game-related properties
        gameId: json['gameId']?.toString() ?? '',
        gameUrl: json['gameUrl']?.toString() ?? '',
        verticalLogo: json['verticalLogo']?.toString() ?? '',
        horizontalLogo: json['horizontalLogo']?.toString() ?? '',
        jackpot: json['jackpot']?.toString() ?? '',
        multiple: json['multiple'] ?? 0,
        name: json['name']?.toString() ?? '',
      );
    } catch (e) {
      logger.i('json: $e');
      return Vod(0, '');
    }
  }

  // Helper methods for parsing actors, tags, and internal tags
  static List<Actor> _parseActors(dynamic actorsData) {
    if (actorsData == null) return [];
    return (actorsData as List<dynamic>).map((e) {
      if (e is int) return Actor(e, '', '');
      return Actor.fromJson(e);
    }).toList();
  }

  static List<Tag> _parseTags(dynamic tagsData) {
    if (tagsData == null) return [];
    return (tagsData as List<dynamic>).map((e) {
      if (e is int) return Tag(e, '');
      return Tag.fromJson(e);
    }).toList();
  }

  static List<int> _parseInternalTags(dynamic internalTagsData) {
    if (internalTagsData == null) return [];
    return List<int>.from(internalTagsData);
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
    videoFavoriteTimes = int.parse(json['videoFavoriteTimes'].toString());
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
    final systemConfigController = Get.find<SystemConfigController>();
    if (videoUrl != null && videoUrl!.isNotEmpty) {
      // logger.i(videoUrlUd);
      String uri = videoUrl!.replaceAll('\\', '/').replaceAll('//', '/');
      // logger.i(uri);
      if (uri.startsWith('http')) {
        return uri;
      }
      String id = uri.substring(uri.indexOf('/') + 1);
      return '${systemConfigController.vodHost.value}/$id/$id.m3u8';
    }
    return null;
  }
}
