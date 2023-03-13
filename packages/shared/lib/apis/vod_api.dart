import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:logger/logger.dart';
import '../models/block_vod.dart';
import '../models/channel_info.dart';
import '../models/short_video_detail.dart';
import '../models/video.dart';
import '../models/vod.dart';
import '../services/system_config.dart';
import '../utils/fetcher.dart';

final systemConfig = SystemConfig();
final logger = Logger();

class VodApi {
  Future<String> purchase(int videoId) async {
    var res = await fetcher(
        url: '${systemConfig.apiHost}/public/videos/video/purchase',
        method: 'POST',
        body: {'videoId': videoId});
    if (res.data['code'] != '00') {
      return '';
    }
    return res.data['data'];
    // 00 購買成功
    // 01 點數不足
    // 02 重複購買
  }

  Future<BlockVod> getSimpleManyBy({
    required int page,
    int limit = 20,
    String? tags,
    String? publisherId,
    String? actors,
    String? regionId,
    String? film,
    int belong = 0,
    int order = 0,
    int chargeTypeId = 0,
  }) async {
    String queryString = '';
    if (tags != null && tags != '') {
      queryString += '&tags=$tags';
    }
    if (publisherId != null && publisherId != '') {
      queryString += '&publisherId=$publisherId';
    }
    if (actors != null && actors != '') {
      queryString += '&actors=$actors';
    }
    if (regionId != null && regionId != '') {
      queryString += '&regionId=$regionId';
    }
    if (film != null && film != '') {
      queryString += '&film=$film';
    }
    if (chargeTypeId != 0) {
      queryString += '&chargeType=$chargeTypeId';
    }

    var res = await fetcher(
        url:
            '/video/list?page=$page&limit=$limit&belong=$belong&order=$order$queryString');

    if (res.data['code'] != '00') {
      return BlockVod([], 0);
    }
    return BlockVod(
        List.from(
            (res.data['data'] as List<dynamic>).map((e) => Vod.fromJson(e))),
        res.data['total']);
  }

  Future<List<Vod>> searchMany(String keyword) async {
    var res = await fetcher(
        url:
            '${systemConfig.apiHost}/public/videos/video/search?keyword=$keyword');
    if (res.data['code'] != '00') {
      return [];
    }
    return List.from(
        (res.data['data'] as List<dynamic>).map((e) => Vod.fromJson(e)));
  }

  Future<BlockVod> getManyByChannel(int blockId, {int? offset = 1}) async {
    var res = await fetcher(
        url:
            '${systemConfig.apiHost}/public/videos/video/index?areaId=$blockId&offset=$offset');
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
      print(e);
    }
    return BlockVod([], 0);
  }

  // Future<List<Block>> getManyByChannel2(int blockId, {int? offset = 1}) async {
  //   var res = await fetcher(
  //       url:
  //           '${systemConfig.apiHost}/public/videos/video/index?areaId=$blockId&offset=$offset');
  //   if (res.data['code'] != '00') {
  //     return [];
  //   }
  //   try {
  //     var result = Block.fromJson(res.data['data']);
  //     return List.from([result]);
  //   } catch (e) {
  //     print(e);
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
            '${systemConfig.apiHost}/public/videos/video/moreVideo?page=$page&limit=$limit&areaId=$areaId');
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
      print(e);
    }
    return BlockVod([], 0);
  }

  Future<Vod> getVodUrl(int vodId) async {
    var res = await fetcher(
        url: '${systemConfig.apiHost}/public/videos/video/videoUrl?id=$vodId');
    if (res.data['code'] != '00') {
      return Vod(0, '');
    }
    try {
      return Vod.fromJson(res.data['data']);
    } catch (e) {
      return Vod(0, '');
    }
  }

  Future<Vod> refreshVodUrl(Vod vod) async {
    var res = await fetcher(
        url:
            '${systemConfig.apiHost}/public/videos/video/videoUrl?id=${vod.id}');
    if (res.data['code'] != '00') {
      return Vod(0, '');
    }
    try {
      // return vod.updateUrl(res.data['data']);
      return Vod.fromJson(res.data['data']);
    } catch (e) {
      print(e);
      return vod;
    }
  }
  // get('/video/videoUrl?id=${vod.id}').then((value) {
  //   var res = (value.body as Map<String, dynamic>);
  //   if (res['code'] != '00') {
  //     return Vod(0, '');
  //   }
  //   try {
  //     return vod.updateUrl(res['data']);
  //   } catch (e) {
  //     print(e);
  //     return vod;
  //   }
  // });

  Future<Vod> getVodDetail(Vod vod) async {
    var res = await fetcher(
        url:
            '${systemConfig.apiHost}/public/videos/video/videoDetail?id=${vod.id}');
    if (res.data['code'] != '00') {
      return vod;
    }
    try {
      return vod.fillDetail(res.data['data']);
    } catch (e) {
      return vod;
    }
  }

  Future<List<Video>> getFollows() async {
    var res = await fetcher(
        url: '${systemConfig.apiHost}/public/videos/video/shortVideo/follow');
    if (res.data['code'] != '00') {
      return [];
    }
    return List.from(
        (res.data['data'] as List<dynamic>).map((e) => Video.fromJson(e)));
  }

  Future<List<Video>> getRecommends() async {
    var res = await fetcher(
        url: '${systemConfig.apiHost}/public/videos/video/recommend');
    if (res.data['code'] != '00') {
      return [];
    }
    return List.from(
        (res.data['data'] as List<dynamic>).map((e) => Video.fromJson(e)));
  }

  Future<List<Video>> getPopular() async {
    var res = await fetcher(
        url: '${systemConfig.apiHost}/public/videos/video/shortVideo/popular');
    if (res.data['code'] != '00') {
      return [];
    }
    return List.from(
        (res.data['data'] as List<dynamic>).map((e) => Video.fromJson(e)));
  }

  Future<ShortVideoDetail> getShortVideoDetailById(int id) async {
    var res = await fetcher(
        url:
            '${systemConfig.apiHost}/public/videos/video/shortVideoDetail?id=$id');
    if (res.data['code'] != '00') {
      return ShortVideoDetail.fromJson({});
    }
    return ShortVideoDetail.fromJson(res.data['data']);
  }

  Future<Video> getById(int videoId) async {
    var res = await fetcher(
        url:
            '${systemConfig.apiHost}/public/videos/video/shortVideoDetail?id=$videoId');

    try {
      return Video.fromJson(res.data['data']);
    } catch (e) {
      return Video.fromJson({});
    }
  }

  // Future<List<Block>> getBlockVodsByChannel(int channelId,
  //     {int offset = 1}) async {
  //   const device = {
  //     'web': 1,
  //     'ios': 2,
  //     'android': 3,
  //   };
  //   int? deviceId = device['web'];

  //   if (!kIsWeb) {
  //     if (Platform.isIOS) {
  //       deviceId = device['ios'];
  //     } else {
  //       deviceId = device['android'];
  //     }
  //   }

  //   var res = await fetcher(
  //       url:
  //           '${systemConfig.apiHost}/public/videos/video/index?offset=$offset&channelId=$channelId&deviceId=$deviceId');

  //   try {
  //     return List.from(
  //         (res.data as List<dynamic>).map((e) => Block.fromJson(e)));
  //   } catch (e) {
  //     return [];
  //   }
  // }

  // Future<List<Block>> getBlockVodsByChannelAds(int channelId,
  //     {int offset = 1}) async {
  //   const device = {
  //     'web': 1,
  //     'ios': 2,
  //     'android': 3,
  //   };
  //   int? deviceId = device['web'];

  //   if (!kIsWeb) {
  //     if (Platform.isIOS) {
  //       deviceId = device['ios'];
  //     } else {
  //       deviceId = device['android'];
  //     }
  //   }

  //   var res = await fetcher(
  //       url:
  //           '${systemConfig.apiHost}/public/videos/video/index/channelAreaBanner?offset=$offset&channelId=$channelId&deviceId=$deviceId');
  //   try {
  //     return List.from((res.data['data']['videoIntegrateAds'] as List<dynamic>)
  //         .map((e) => Block.fromJson(e)));
  //   } catch (e) {
  //     return [];
  //   }
  // }

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
            '${systemConfig.apiHost}/public/videos/video/v2/videoBlocks?offset=$offset&channelId=$channelId&deviceId=$deviceId');
    try {
      return ChannelInfo.fromJson(res.data['data']);
    } catch (e) {
      return ChannelInfo();
    }
  }
}
