import 'package:wgp_video_h5app/controllers/index.dart';
import 'package:wgp_video_h5app/models/index.dart';
import 'package:wgp_video_h5app/models/videos_tag.dart';
import 'package:wgp_video_h5app/providers/index.dart';

import '../models/pager.dart';

class TagProvider extends BaseProvider {
  @override
  void onInit() {
    httpClient.baseUrl = '${AppController.cc.endpoint.getApi()}/public/tags';
    super.onInit();
  }

  Future<List<Tag>> getManyBy({
    required int page,
    String? name,
    int? sortBy,
    required int region,
  }) =>
      get('/tag/list?page=$page&limit=48&name=$name&region=$region&isSortByVideos=${sortBy ?? 0}')
          .then((value) {
        // print('$region, $page, $sortBy, $name');
        var res = (value.body as Map<String, dynamic>);
        // var total = res['data']['total'];
        // print((res['data']['data'] as List<dynamic>).length);
        if (res['code'] != '00') {
          return [];
        }
        return List.from((res['data']['data'] as List<dynamic>)
            .map((e) => Actor.fromJson(e)));
      });

  Future<List<Tag>> searchBy({
    required int page,
    String? name,
  }) =>
      get('/tag/list?page=$page&limit=48&name=$name&isSortByVideos=0')
          .then((value) {
        var res = (value.body as Map<String, dynamic>);
        // var total = res['data']['total'];
        // print((res['data']['data'] as List<dynamic>).length);
        if (res['code'] != '00') {
          return [];
        }
        return List.from(
            (res['data']['data'] as List<dynamic>).map((e) => Tag.fromJson(e)));
      });

  Future<List<VideoTags>> getAllShortVideoPopular() =>
      get('/tag/shortVideoPopular')
          .then((value) {
        var res = (value.body as Map<String, dynamic>);
        // var total = res['data']['total'];
        // print((res['data']['data'] as List<dynamic>).length);
        if (res['code'] != '00') {
          return [];
        }
        return List.from((res['data'] as List<dynamic>).map((e) => VideoTags.fromJson(e)));
      });


  Future<SupplierTag> getOneTag(int id) =>
      get('/tag/statistics?id=$id').then((value) {
        // print(value.body);
        var res = (value.body as Map<String, dynamic>);
        if (res['code'] != '00') {
          return SupplierTag(0);
        }
        return SupplierTag.fromJson(res['data'][0]);
      });

  Future<Pager<VideoTag>> getShortVideoById(
  {
    required String id,
    required int page,
    required int limit,
  }) =>
      get('/tag/shortVideo?page=$page&limit=$limit&id=$id')
          .then((value) {
        var res = (value.body as Map<String, dynamic>);
        // var total = res['data']['total'];
        // print((res['data']['data'] as List<dynamic>).length);
        if (res['code'] != '00') {
          return Future.delayed(Duration.zero);
        }

        return Pager.fromJson(res['data'], List.from((res['data']['data'] as List<dynamic>).map((e) => VideoTag.fromJson(e))));
      });

  Future<List<VideoTags>> searchShortVideoPopular(String keyword) =>
      get('/tag/searchShortVideoPopular?keyword=$keyword')
          .then((value) {
        var res = (value.body as Map<String, dynamic>);
        // var total = res['data']['total'];
        // print((res['data']['data'] as List<dynamic>).length);
        if (res['code'] != '00') {
          return [];
        }
        return List.from((res['data'] as List<dynamic>).map((e) => VideoTags.fromJson(e)));
      });

  Future<Tag> getOne(int tagId) => get('/tag?id=$tagId').then((value) {
        // print(value.body);
        var res = (value.body as Map<String, dynamic>);
        if (res['code'] != '00') {
          return Tag(0, '標籤');
        }
        return Tag.fromJson(res['data']);
      });

  Future<List<Tag>> getPopular({int page = 1, int limit = 100}) async {
    var value = await get('/tag/popular?page=$page&limit=$limit');
    var res = (value.body as Map<String, dynamic>);
    if (res['code'] != '00') {
      return [];
    }
    return List.from(
        (res['data'] as List<dynamic>).map((e) => Tag.fromJson(e)));
  }

  Future<BlockVod> getRecommendVod({
    int? tagId,
    int? vodId,
    List<int>? tagIds,
    int page = 1,
    int limit = 100,
  }) async {
    var url = '/tag/views?page=$page&limit=$limit&';
    if (tagIds?.isNotEmpty == true && vodId != null) {
      url = '${url}tagId=${(tagIds ?? []).join(',')}&excludeId=$vodId';
    } else {
      if (tagId != null && tagId != 0) {
        url = '${url}tagId=$tagId&';
      }
      if (vodId != null) {
        url = '${url}excludeId=$vodId';
      }
      if ((tagId == null || tagId == 0) && vodId == null) {
        url = '${url}tagId=&excludeId=';
      }
    }
    // print(url);
    var value = await get(url);
    var res = (value.body as Map<String, dynamic>);
    if (res['code'] != '00') {
      return BlockVod([], 0);
    }
    List<Vod> vods =
        List.from((res['data'] as List<dynamic>).map((e) => Vod.fromJson(e)));
    return BlockVod(vods, vods.length);
  }


  Future<TagVideos> getPlayList({
    required int tagId,
    required int videoId,
  }) =>
      get('/tag/playlist?tagId=$tagId&videoId=$videoId')
          .then((value) {
        print('/tag/playlist?tagId=$tagId&videoId=$videoId');
        var res = (value.body as Map<String, dynamic>);
        if (res['code'] != '00') {
          return Future.delayed(Duration.zero);
        }
        return TagVideos.fromJson(res['data'][0]);
      });
}
