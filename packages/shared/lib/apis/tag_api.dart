import 'package:get/get.dart';

import '../controllers/system_config_controller.dart';
import '../models/block_vod.dart';
import '../models/tag.dart';
import '../models/videos_tag.dart';
import '../models/vod.dart';
import '../utils/fetcher.dart';

class TagApi {
  static final TagApi _instance = TagApi._internal();

  TagApi._internal();

  factory TagApi() {
    return _instance;
  }

  final SystemConfigController _systemConfigController =
      Get.find<SystemConfigController>();

  String get apiHost => _systemConfigController.apiHost.value!;
  String get apiPrefix => '$apiHost/public/tags';

  Future<List<Tag>> getManyBy({
    required int page,
    String? name,
    int? sortBy,
    required int region,
  }) async {
    var res = await fetcher(
        url:
            '$apiPrefix/tag/list?page=$page&limit=48&name=$name&region=$region&isSortByVideos=${sortBy ?? 0}');
    if (res.data['code'] != '00') {
      return [];
    }
    return List.from((res.data['data']['data'] as List<dynamic>)
        .map((e) => Tag.fromJson(e)));
  }

  Future<List<Tag>> searchBy({
    required int page,
    String? name,
  }) async {
    var res = await fetcher(
        url:
            '$apiPrefix/tag/list?page=$page&limit=48&name=$name&isSortByVideos=0');
    if (res.data['code'] != '00') {
      return [];
    }
    return List.from((res.data['data']['data'] as List<dynamic>)
        .map((e) => Tag.fromJson(e)));
  }

  Future<List<VideoTags>> getAllShortVideoPopular() async {
    var res = await fetcher(url: '$apiPrefix/tag/shortVideoPopular');
    if (res.data['code'] != '00') {
      return [];
    }
    return List.from(
        (res.data['data'] as List<dynamic>).map((e) => VideoTags.fromJson(e)));
  }

  Future<List<VideoTags>> searchShortVideoPopular(String keyword) async {
    var res = await fetcher(
        url: '$apiPrefix/tag/searchShortVideoPopular?keyword=$keyword');
    if (res.data['code'] != '00') {
      return [];
    }
    return List.from(
        (res.data['data'] as List<dynamic>).map((e) => VideoTags.fromJson(e)));
  }

  Future<Tag> getOne(int tagId) async {
    var res = await fetcher(url: '$apiPrefix/tag?id=$tagId');
    if (res.data['code'] != '00') {
      return Tag(0, '標籤');
    }
    return Tag.fromJson(res.data['data']);
  }

  Future<List<Tag>> getPopular({int page = 1, int limit = 100}) async {
    var value = await fetcher(
        url: '$apiHost/api/v1/tag/popular?page=$page&limit=$limit');
    var res = (value.data as Map<String, dynamic>);
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
    var url = '$apiPrefix/tag/views?page=$page&limit=$limit&';
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
    var value = await fetcher(url: url);
    var res = (value.data as Map<String, dynamic>);
    if (res['code'] != '00') {
      return BlockVod([], 0);
    }
    List<Vod> vods =
        List.from((res['data'] as List<dynamic>).map((e) => Vod.fromJson(e)));
    return BlockVod(vods, vods.length);
  }

  Future<List<Vod>> getPlayList({
    required int tagId,
    required int videoId,
  }) async {
    var res = await fetcher(
        url: '$apiPrefix/tag/playlist?tagId=$tagId&videoId=$videoId');
    if (res.data['code'] != '00') {
      return [];
    }
    return List.from(
        (res.data['data'] as List<dynamic>).map((e) => Vod.fromJson(e)));
  }

  Future<BlockVod> getShortVideoByTagId({
    required int page,
    int limit = 10,
    required int id,
  }) async {
    var res = await fetcher(
        url:
            '$apiHost/api/v1/video/tag-short-videos?page=$page&limit=$limit&id=$id');
    if (res.data['code'] != '00') {
      return BlockVod([], 0);
    }
    return BlockVod(
        List.from((res.data['data']['data'] as List<dynamic>)
            .map((e) => Vod.fromJson(e))
            .toList()),
        res.data['data']['total'] ?? limit * (page + 1));
  }
}
