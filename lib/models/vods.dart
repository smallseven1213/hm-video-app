import 'package:decimal/decimal.dart';
import 'package:wgp_video_h5app/controllers/index.dart';
import 'package:wgp_video_h5app/models/index.dart';

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
  Decimal? point = Decimal.zero;
  Decimal? buyPoint = Decimal.zero;
  List<Vod>? belongVods;

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
  });

  getCoverHorizontalUrl() =>
      // "${AppController.cc.endpoint.getPhotoSidPreviewPrefix()}$coverHorizontal";
      coverHorizontal;
  getCoverVerticalUrl() =>
      // "${AppController.cc.endpoint.getPhotoSidPreviewPrefix()}$coverVertical";
      coverVertical;
  getTimeString() =>
      ((timeLength ?? 0) / 3600).floor().toString().padLeft(2, '0') +
      ':' +
      (((timeLength ?? 0) / 60).floor() % 60).toString().padLeft(2, '0') +
      ':' +
      ((timeLength ?? 0) % 60).floor().toString().padLeft(2, '0');

  // setPoint(Decimal _point) {
  //   point = _point;
  // }

  factory Vod.fromJson(Map<String, dynamic> json) {
    try {
      return Vod(
        json['id'],
        json['title'],
        subScript: json['subScript'] ?? 0,
        timeLength: json['timeLength'] ?? 0,
        coverVertical: json['coverVertical'] ?? '',
        coverHorizontal: json['coverHorizontal'] ?? '',
        // videoUrlHd: json['videoUrlHd'],
        // videoUrlSd: json['videoUrlSd'],
        // videoUrlUd: json['videoUrlUd'],
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
        point: json['points'] == null
            ? null
            : Decimal.parse(json['points'].toString()),
        buyPoint: json['buyPoints'] == null
            ? null
            : Decimal.parse(json['buyPoints'].toString()),
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
        // internalTags: (json['internalTag'] ?? json['internalTags']) == null
        //     ? []
        //     : List.from(
        //         ((json['internalTag'] ?? json['internalTags']) as List<dynamic>)
        //             .map((e) {
        //         if (e is int) {
        //           return Tag(e, '');
        //         }
        //         return Tag.fromJson(e);
        //       })),
        region: json['region'],
        publisher: (json['publisher'] == null)
            ? null
            : Publisher.fromJson(json['publisher']),
        supplier: null,
        // supplier: json['supplier'] == null
        //     ? null
        //     : Supplier.fromJson(json['supplier']),
        belongVods: json['belongVods'] == null
            ? null
            : List.from((json['belongVods'] as List<dynamic>)
                .map((e) => Vod.fromJson(e))),
      );
    } catch (e) {
      print('json: $e');
      return Vod(0, '');
    }
  }

  Vod fillDetail(Map<String, dynamic> json) {
    // externalId = json['externalId'];
    // title = json['title'];
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
    // TODO: Supplier.fromJson has a bug
    // supplier =
    //     (json['supplier'] == null) ? null : Supplier.fromJson(json['supplier']);
    belongVods = json['belongVods'] == null
        ? null
        : List.from(
            (json['belongVods'] as List<dynamic>).map((e) => Vod.fromJson(e)));
    return this;
  }

  Vod updateUrl(Map<String, dynamic> json) {
    // id = json['id'];
    // externalId = json['externalId'];
    // title = json['title'];
    // film = json['film'];
    // chargeType = json['chargeType'];
    // coverVertical = json['coverVertical'];
    // coverHorizontal = json['coverHorizontal'];
    videoUrl = json['videoUrl'];
    isAvailable = json['isPreview'] ?? false;
    isCollect = json['isCollected'] ?? false;
    ;
    point = json['points'] == null
        ? null
        : Decimal.parse(json['points'].toString());
    buyPoint = json['buyPoints'] == null
        ? null
        : Decimal.parse(json['buyPoints'].toString());
    return this;
  }

  String? getVideoUrl() {
    if (videoUrl != null && videoUrl!.isNotEmpty) {
      // print(videoUrlUd);
      String uri = videoUrl!.replaceAll('\\', '/').replaceAll('//', '/');
      // print(uri);
      if (uri.startsWith('http')) {
        return uri;
      }
      String id = uri.substring(uri.indexOf('/') + 1);
      return '${AppController.cc.endpoint.getVideoPrefix()}/$id/$id.m3u8';
    }
    return null;
  }

  String getViewTimes() {
    var times = (videoViewTimes ?? 0);
    var timeStr = (videoViewTimes ?? 0).toString();
    return timeStr.length > 9
        ? '${(times / 1000000000).floor()}G'
        : (timeStr.length > 6
            ? '${(times / 1000000).floor()}M'
            : (timeStr.length > 3 ? '${(times / 1000).floor()}K' : timeStr));
  }
}
