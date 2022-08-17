import 'package:wgp_video_h5app/controllers/index.dart';
import 'package:wgp_video_h5app/models/index.dart';
import 'package:wgp_video_h5app/models/video.dart';
import 'package:wgp_video_h5app/providers/index.dart';

import '../models/short_video_detail.dart';

class BlockVod {
  final int total;
  final List<Vod> vods;
  BlockVod(this.vods, this.total);
}

class VodProvider extends BaseProvider {
  @override
  void onInit() {
    httpClient.baseUrl = '${AppController.cc.endpoint.getApi()}/public/videos';
    super.onInit();
  }

  Future<String> purchase(int videoId) =>
      post('/video/purchase', {'videoId': videoId}).then((value) {
        var res = (value.body as Map<String, dynamic>);
        return res['code'];
        // 00 購買成功
        // 01 點數不足
        // 02 重複購買
      });

  // Future<Vod?> getOne(int vodId) => get('/video?id=$vodId').then((value) {
  //       // print(value.body);
  //       var res = (value.body as Map<String, dynamic>);
  //       if (res['code'] != '00') {
  //         return null;
  //       }
  //       // print(vodId);
  //       // print(res['data'].toString());
  //       try {
  //         return Vod.fromJson(res['data']);
  //       } catch (e) {
  //         print(e);
  //         return Vod(0, '');
  //       }
  //     });

  Future<BlockVod> getSimpleManyBy({
    required int page,
    int limit = 20,
    String tags = '',
    String publisherId = '',
    String actors = '',
    String regionId = '',
    String film = '',
    int belong = 0,
    int order = 0,
  }) =>
      get('/video/list?page=$page&limit=$limit&tags=$tags&publisherId=$publisherId&actors=$actors&regionId=$regionId&belong=$belong&film=$film&order=$order')
          .then((value) {
        var res = (value.body as Map<String, dynamic>);
        if (res['code'] != '00') {
          return BlockVod([], 0);
        }
        // print(res['data']);
        return BlockVod(
            List.from((res['data']['data'] as List<dynamic>)
                .map((e) => Vod.fromJson(e))),
            res['data']['total']);
      });

  Future<List<Vod>> searchMany(String keyword) =>
      get('/video/search?keyword=$keyword').then((value) {
        var res = (value.body as Map<String, dynamic>);
        if (res['code'] != '00') {
          return [];
        }
        // print(res['data']);
        return List.from(
            (res['data'] as List<dynamic>).map((e) => Vod.fromJson(e)));
      });

  Future<BlockVod> getManyByChannel(int blockId, {int? offset = 1}) =>
      get('/video/index?areaId=$blockId&offset=$offset').then((value) {
        // print(value.body);
        var res = (value.body as Map<String, dynamic>);
        if (res['code'] != '00') {
          return BlockVod([], 0);
        }
        try {
          // print(res['data']['data']);
          // print((res['data']['data'] as List<dynamic>)
          //     .map((e) => Vod.fromJson(e)));
          var bb = BlockVod(
            List.from((res['data']['data'] as List<dynamic>)
                .map((e) => Vod.fromJson(e))),
            res['data']['total'],
          );
          // print(bb.total);
          return bb;
        } catch (e) {
          print(e);
        }
        return BlockVod([], 0);
      });

  Future<BlockVod> getMoreMany(
    int areaId, {
    int page = 1,
    int limit = 100,
  }) =>
      get('/video/moreVideo?page=$page&limit=$limit&areaId=$areaId')
          .then((value) {
        // print(value.body);
        var res = (value.body as Map<String, dynamic>);
        if (res['code'] != '00') {
          return BlockVod([], 0);
        }
        try {
          // print(res['data']['data']);
          // print((res['data']['data'] as List<dynamic>)
          //     .map((e) => Vod.fromJson(e)));
          var bb = BlockVod(
            List.from((res['data']['data'] as List<dynamic>)
                .map((e) => Vod.fromJson(e))),
            res['data']['total'],
          );
          // print(bb.total);
          return bb;
        } catch (e) {
          print(e);
        }
        return BlockVod([], 0);
      });

  // Future<Decimal> getVodPoint(int vodId) =>
  //     get('/video/point?id=$vodId').then((value) {
  //       var res = (value.body as Map<String, dynamic>);
  //       if (res['code'] != '00') {
  //         return Decimal.zero;
  //       }
  //       // print(res['data']);
  //       return Decimal.parse(res['data']['points']);
  //     });

  Future<Vod> getVodUrl(int vodId) =>
      get('/video/videoUrl?id=$vodId').then((value) {
        var res = (value.body as Map<String, dynamic>);
        if (res['code'] != '00') {
          return Vod(0, '');
        }
        try {
          return Vod.fromJson(res['data']);
        } catch (e) {
          print(e);
          return Vod(0, '');
        }
      });

  Future<Vod> refreshVodUrl(Vod vod) =>
      get('/video/videoUrl?id=${vod.id}').then((value) {
        var res = (value.body as Map<String, dynamic>);
        if (res['code'] != '00') {
          return Vod(0, '');
        }
        try {
          return vod.updateUrl(res['data']);
        } catch (e) {
          print(e);
          return vod;
        }
      });

  Future<Vod> getVodDetail(Vod vod) =>
      get('/video/videoDetail?id=${vod.id}').then((value) {
        var res = (value.body as Map<String, dynamic>);
        if (res['code'] != '00') {
          return vod;
        }
        try {
          return vod.fillDetail(res['data']);
        } catch (e) {
          print(e);
          return vod;
        }
      });

  Future<List<Video>> getFollows() =>
      get('/video/shortVideo/follow').then((value) {
        var res = (value.body as Map<String, dynamic>);
        if (res['code'] != '00') {
          return [];
        }
        // print(res['data']);
        return List.from(
            (res['data'] as List<dynamic>).map((e) => Video.fromJson(e)));
      });

  Future<List<Video>> getRecommends() => get('/video/recommend').then((value) {
        var res = (value.body as Map<String, dynamic>);
        if (res['code'] != '00') {
          return [];
        }
        // print(res['data']);
        return List.from(
            (res['data'] as List<dynamic>).map((e) => Video.fromJson(e)));
      });

  Future<ShortVideoDetail> getShortVideoDetailById(int id) =>
      get('/video/shortVideoDetail?id=$id').then((value) {
        var res = (value.body as Map<String, dynamic>);
        return ShortVideoDetail.fromJson(res['data']);
      });

  Future<Video> getById(int videoId) =>
      get('/video/videoUrl?id=$videoId').then((value) {
        var res = (value.body as Map<String, dynamic>);
        return Video.fromJson(res['data']);
      });

  Future<List<Block>> getBlockVodsByChannel(int channelId, {int offset = 1}) =>
      get('/video/index?offset=$offset&channelId=$channelId').then((value) {
        var res = (value.body as Map<String, dynamic>);
        return List.from(
            (res['data'] as List<dynamic>).map((e) => Block.fromJson(e)));
      });
}
