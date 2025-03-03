import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:game/models/hm_api_response_pagination.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/models/hm_api_response.dart';
import '../controllers/system_config_controller.dart';
import '../enums/shorts_type.dart';
import '../models/area_info_with_block_vod.dart';
import '../models/block_vod.dart';
import '../models/channel_info.dart';
import '../models/short_video_detail.dart';
import '../models/vod.dart';
import '../utils/fetcher.dart';

final logger = Logger();

class VodApi {
  static final VodApi _instance = VodApi._internal();

  VodApi._internal();

  factory VodApi() {
    return _instance;
  }

  final SystemConfigController _systemConfigController =
      Get.find<SystemConfigController>();

  String get apiHost => _systemConfigController.apiHost.value!;

  Future<HMApiResponse> purchase(int videoId) async {
    var value = await fetcher(
        url: '$apiHost/public/videos/video/purchase',
        method: 'POST',
        body: {'videoId': videoId});

    var res = (value.data as Map<String, dynamic>);
    return HMApiResponse.fromJson(res);

    // 00 購買成功
    // 01 點數不足
    // 02 重複購買
  }

  Future<BlockVod> getSimpleManyBy({
    required int page,
    int limit = 20,
    String? queryString = '',
    int belong = 0,
    int order = 0,
    int chargeTypeId = 0,
    int film = 1,
  }) async {
    if (belong != 0 && queryString != null) {
      queryString += '&belong=$belong';
    }

    var res = await fetcher(
        url:
            '$apiHost/api/v1/video/videos?page=$page&limit=$limit&film=$film&$queryString');

    if (res.data['code'] != '00') {
      return BlockVod([], 0);
    }

    return BlockVod(
      List.from((res.data['data']['data'] as List<dynamic>)
          .map((e) => Vod.fromJson(e))
          .toList()),
      res.data['data']['total'],
    );
  }

  Future<BlockVod> searchMany(
      String keyword, int page, int limit, int film) async {
    var res = await fetcher(
        url:
            '$apiHost/api/v1/video/search?keyword=$keyword&page=$page&limit=$limit&film=$film');
    if (res.data['code'] != '00') {
      return BlockVod([], 0);
    }
    try {
      var bb = BlockVod(
        List.from((res.data['data']['data'] as List<dynamic>)
            .map((e) => Vod.fromJson(e))),
        res.data['data']['total'],
      );
      return bb;
    } catch (e) {
      logger.i(e);
    }
    return BlockVod([], 0);
  }

  Future<BlockVod> getSameTagVod({
    required int tagId,
    required int page,
    required int limit,
  }) async {
    var res = await fetcher(
        url:
            '$apiHost/api/v1/video/tag-videos?id=$tagId&film=1&page=$page&limit=$limit');
    if (res.data['code'] != '00') {
      return BlockVod([], 0);
    }
    try {
      var bb = BlockVod(
        List.from((res.data['data']['data'] as List<dynamic>)
            .map((e) => Vod.fromJson(e))),
        res.data['data']['total'],
      );
      return bb;
    } catch (e) {
      logger.i(e);
    }
    return BlockVod([], 0);
  }

  Future<BlockVod> getManyByChannel(int blockId, {int? offset = 1}) async {
    var res = await fetcher(
        url:
            '$apiHost/public/videos/video/index?areaId=$blockId&offset=$offset');
    if (res.data['code'] != '00') {
      return BlockVod([], 0);
    }
    try {
      var bb = BlockVod(
        List.from((res.data['data']['data'] as List<dynamic>)
            .map((e) => Vod.fromJson(e))),
        res.data['data']['total'],
      );
      return bb;
    } catch (e) {
      logger.i(e);
    }
    return BlockVod([], 0);
  }

  // Future<List<Block>> getManyByChannel2(int blockId, {int? offset = 1}) async {
  //   var res = await fetcher(
  //       url:
  //           '$apiHost/public/videos/video/index?areaId=$blockId&offset=$offset');
  //   if (res.data['code'] != '00') {
  //     return [];
  //   }
  //   try {
  //     var result = Block.fromJson(res.data['data']);
  //     return List.from([result]);
  //   } catch (e) {
  //     logger.i(e);
  //   }
  //   return [];
  // }

  Future<BlockVod> getMoreMany(
    int areaId, {
    int page = 1,
    int limit = 100,
  }) async {
    var res = await fetcher(
        url:
            '$apiHost/api/v1/area/videos/more?page=$page&limit=$limit&areaId=$areaId');
    if (res.data['code'] != '00') {
      return BlockVod([], 0);
    }
    try {
      var bb = BlockVod(
        List.from((res.data['data']['data'] as List<dynamic>)
            .map((e) => Vod.fromJson(e))),
        res.data['data']['total'],
      );
      return bb;
    } catch (e) {
      logger.i(e);
    }
    return BlockVod([], 0);
  }

  Future<Vod> getVodUrl(int vodId) async {
    var res =
        await fetcher(url: '$apiHost/public/videos/video/videoUrl?id=$vodId');
    if (res.data['code'] != '00') {
      return Vod(0, '');
    }
    try {
      return Vod.fromJson(res.data['data']);
    } catch (e) {
      return Vod(0, '');
    }
  }

  // Future<Vod> refreshVodUrl(Vod vod) async {
  //   var res = await fetcher(
  //       url:
  //           '$apiHost/public/videos/video/videoUrl?id=${vod.id}');
  //   if (res.data['code'] != '00') {
  //     return Vod(0, '');
  //   }
  //   try {
  //     // return vod.updateUrl(res.data['data']);
  //     return Vod.fromJson(res.data['data']);
  //   } catch (e) {
  //     logger.i(e);
  //     return vod;
  //   }
  // }
  // get('/video/videoUrl?id=${vod.id}').then((value) {
  //   var res = (value.body as Map<String, dynamic>);
  //   if (res['code'] != '00') {
  //     return Vod(0, '');
  //   }
  //   try {
  //     return vod.updateUrl(res['data']);
  //   } catch (e) {
  //     logger.i(e);
  //     return vod;
  //   }
  // });

  Future<Vod> getVodDetail(int vodId) async {
    var res = await fetcher(url: '$apiHost/api/v1/video/detail?id=$vodId');
    if (res.data['code'] != '00') {
      return res.data['data'];
    }
    try {
      return Vod.fromJson(res.data['data']);
    } catch (e) {
      return Vod(0, '');
    }
  }

  Future<HMApiResponsePaginationData<List<Vod>>> getFollows(
      {int? page = 1}) async {
    var res = await fetcher(
        url: '$apiHost/api/v1/user/feed/follow-videos?page=$page&limit=50');
    if (res.data['code'] != '00') {
      return HMApiResponsePaginationData(
        data: [],
      );
    }
    var data = res.data['data'];
    var vods = (data['data'] as List<dynamic>)
        .map((e) => Vod.fromJson(e as Map<String, dynamic>))
        .toList();
    return HMApiResponsePaginationData<List<Vod>>(
      limit: data['limit'],
      total: data['total'],
      current: data['current'],
      data: vods,
    );
  }

  Future<HMApiResponsePaginationData<List<Vod>>> getRecommends(
      {int? page = 1}) async {
    var res = await fetcher(
        url:
            '$apiHost/api/v1/video/recommend-short-videos?page=$page&limit=50');
    if (res.data['code'] != '00') {
      return HMApiResponsePaginationData(
        data: [],
      );
    }
    var data = res.data['data'];
    var vods = (data['data'] as List<dynamic>)
        .map((e) => Vod.fromJson(e as Map<String, dynamic>))
        .toList();
    return HMApiResponsePaginationData<List<Vod>>(
      limit: data['limit'],
      total: data['total'],
      current: data['current'],
      data: vods,
    );
  }

  Future<List<Vod>> getPopular(int areaId, int videoId) async {
    var res = await fetcher(
        url:
            '$apiHost/public/videos/video/shortVideo/popular?areaId=$areaId&videoId=$videoId');
    if (res.data['code'] != '00') {
      return [];
    }
    return List.from(
        (res.data['data'] as List<dynamic>).map((e) => Vod.fromJson(e)));
  }

  Future<ShortVideoDetail> getShortVideoDetailById(int id) async {
    var res = await fetcher(url: '$apiHost/api/v1/video/short-detail?id=$id');
    if (res.data['code'] != '00') {
      return ShortVideoDetail.fromJson({});
    }
    return ShortVideoDetail.fromJson(res.data['data']);
  }

  Future<Vod> getById(int videoId) async {
    var res =
        await fetcher(url: '$apiHost/api/v1/video/short-detail?id=$videoId');

    try {
      return Vod.fromJson(res.data['data']);
    } catch (e) {
      return Vod.fromJson({});
    }
  }

  Future<ChannelInfo> getBlockVodsByChannelAds(int channelId,
      {int offset = 1}) async {
    const device = {
      'web': 1,
      'ios': 2,
      'android': 3,
    };
    int? deviceId = device['web'];

    if (!kIsWeb) {
      if (Platform.isIOS) {
        deviceId = device['ios'];
      } else {
        deviceId = device['android'];
      }
    }

    var res = await fetcher(
        url:
            '$apiHost/api/v1/video/channel-videos?channelId=$channelId&offset=$offset&deviceId=$deviceId');
    try {
      return ChannelInfo.fromJson(res.data['data']);
    } catch (e) {
      return ChannelInfo();
    }
  }

  Future<Blocks> getBlockVodsByBlockId(int blockId, {int offset = 1}) async {
    const device = {
      'web': 1,
      'ios': 2,
      'android': 3,
    };
    int? deviceId = device['web'];

    if (!kIsWeb) {
      if (Platform.isIOS) {
        deviceId = device['ios'];
      } else {
        deviceId = device['android'];
      }
    }

    var res = await fetcher(
        url:
            '$apiHost/public/videos/video/v2/videoBlocks?offset=$offset&areaId=$blockId&deviceId=$deviceId');
    try {
      return Blocks.fromJson(res.data['data']);
    } catch (e) {
      logger.i('getBlockVodsByBlockId error: $e');
      return Blocks();
    }
  }

  // 同類型 (internalTagId) 帶空取全部、取前面最多三個
  Future<BlockVod> getVideoByInternalTag(
    String? excludeId,
    String internalTagId,
  ) async {
    var res = await fetcher(
        url:
            '$apiHost/api/v1/video/tag-random-videos?excludeId=$excludeId&internalTagId=$internalTagId');
    if (res.data['code'] != '00') {
      return BlockVod([], 0);
    }
    List<Vod> vods = List.from(
        (res.data['data'] as List<dynamic>).map((e) => Vod.fromJson(e)));
    return BlockVod(
      vods,
      vods.length,
    );
  }

  // 同標籤 (tag) tagId 帶空取全部、取前面最多三個
  Future<BlockVod> getVideoByTags({
    String? excludeId,
    String? tagId,
  }) async {
    String url = '$apiHost/api/v1/video/tag-random-videos';
    List<String> queryParams = [];

    if (excludeId != null) {
      queryParams.add('excludeId=$excludeId');
    }
    if (tagId != null) {
      queryParams.add('tagId=$tagId');
    }

    if (queryParams.isNotEmpty) {
      url += '?${queryParams.join('&')}';
    }

    var res = await fetcher(url: url);

    if (res.data['code'] != '00') {
      return BlockVod([], 0);
    }
    List<Vod> vods = List.from(
        (res.data['data'] as List<dynamic>).map((e) => Vod.fromJson(e)));
    return BlockVod(
      vods,
      vods.length,
    );
  }

  // 同演員: 目前只取一位演員
  Future<BlockVod> getVideoByActorId({
    String? actorId,
    String? excludeId,
  }) async {
    var res = await fetcher(
        url:
            '$apiHost/public/videos/video/sameActors?actorId=$actorId&excludeId=$excludeId');
    if (res.data['code'] != '00') {
      return BlockVod([], 0);
    }
    List<Vod> vods = List.from(
        (res.data['data'] as List<dynamic>).map((e) => Vod.fromJson(e)));
    return BlockVod(
      vods,
      vods.length,
    );
  }

  // search keyword
  Future<List<String>> getSearchKeyword(String keyword) async {
    var res = await fetcher(url: '$apiHost/api/v1/keyword?keyword=$keyword');
    if (res.data['code'] != '00') {
      return [];
    }

    List<String> names = res.data['data']
        .map<String>((dynamic item) => item['name'] as String)
        .toList();

    return names;
  }

  Future<AreaInfoWithBlockVod?> getVideoByAreaId(
    int areaId, {
    int page = 1,
    int limit = 2,
  }) async {
    var res = await fetcher(
        url:
            '$apiHost/api/v1/area/videos?page=$page&limit=$limit&areaId=$areaId');
    if (res.data['code'] != '00') {
      return null;
    }

    var info = res.data['data'];
    var videos = res.data['data']['videos'];
    List<Vod> vods = List.from(
        (videos['data'] as List<dynamic>).map((e) => Vod.fromJson(e)));
    return AreaInfoWithBlockVod(
        film: info['film'],
        id: info['id'],
        name: info['name'],
        template: info['template'],
        videos: BlockVod(
          vods,
          videos['total'],
        ));
  }

  Future<List<Vod>> getPlayList({
    required ShortsType type,
    required int id,
    required int videoId,
  }) async {
    String queryString;
    switch (type) {
      case ShortsType.supplier:
        queryString = 'supplierId=$id';
        break;
      case ShortsType.tag:
        queryString = 'tagId=$id';
        break;
      case ShortsType.area:
        queryString = 'areaId=$id';
        break;
    }

    var res = await fetcher(
        url:
            '$apiHost/api/v1/video/short-videos?$queryString&videoId=$videoId');
    if (res.data['code'] != '00') {
      return [];
    }
    return List.from(
        (res.data['data'] as List<dynamic>).map((e) => Vod.fromJson(e)));
  }
}
