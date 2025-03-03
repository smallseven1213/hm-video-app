import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/system_config_controller.dart';

import '../models/actor.dart';
import '../models/actor_with_vods.dart';
import '../models/block_vod.dart';
import '../models/vod.dart';
import '../utils/fetcher.dart';

final logger = Logger();

class ActorApi {
  static final ActorApi _instance = ActorApi._internal();

  ActorApi._internal();
  factory ActorApi() {
    return _instance;
  }

  final SystemConfigController _systemConfigController =
      Get.find<SystemConfigController>();

  // 动态获取apiPrefix
  String get apiPrefix =>
      "${_systemConfigController.apiHost.value!}/public/actors";
  String get apiHost => _systemConfigController.apiHost.value!;

  Future<List<Actor>> getManyBy({
    required int page,
    int limit = 100,
    String? name,
    int? sortBy,
    int? region,
    bool? isRecommend,
  }) async {
    String nameQuery = name != null ? '&name=$name' : '';
    String regionQuery = region != null ? '&region=$region' : '';
    String isRecommendQuery =
        isRecommend != null ? '&isRecommend=$isRecommend' : '';

    var res = await fetcher(
        url:
            '$apiHost/api/v1/actor?page=$page&limit=$limit$nameQuery$regionQuery$isRecommendQuery&isSortByVideos=${sortBy ?? 0}');
    if (res.data['code'] != '00') {
      return [];
    }
    return List.from((res.data['data']['data'] as List<dynamic>)
        .map((e) => Actor.fromJson(e)));
  }

  Future<List<Actor>> searchBy({
    required int page,
    String? name,
  }) async {
    var res = await fetcher(
        url:
            '$apiHost/api/v1/actor?page=$page&limit=48&name=$name&isSortByVideos=0');
    if (res.data['code'] != '00') {
      return [];
    }
    return List.from((res.data['data']['data'] as List<dynamic>)
        .map((e) => Actor.fromJson(e)));
  }

  Future<Actor> getOne(int actorId) async {
    var res = await fetcher(url: '$apiHost/api/v1/actor/detail?id=$actorId');
    if (res.data['code'] != '00') {
      return Actor(0, '演員', '');
    }
    return Actor.fromJson(res.data['data']);
  }

  Future<BlockVod> getManyLatestVodBy(
      {int page = 1, int limit = 10, required int actorId}) async {
    var res = await fetcher(
        url:
            '$apiHost/api/v1/video/actor-latest-videos?id=$actorId&page=$page&limit=$limit');
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

  Future<BlockVod> getManyHottestVodBy(
      {int page = 1, int limit = 10, required int actorId}) async {
    var res = await fetcher(
        url:
            '$apiHost/api/v1/video/actor-hottest-videos?id=$actorId&page=$page&limit=$limit');
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

  Future<List<ActorWithVod>> getManyPopularActorBy(
      {int page = 1, int limit = 10}) async {
    var res = await fetcher(
        url:
            '$apiHost/api/v1/video/popular-actor-videos?page=$page&limit=$limit');
    if (res.data['code'] != '00') {
      return [];
    }
    return List.from((res.data['data'] as List<dynamic>)
        .map((e) => ActorWithVod(
              Actor.fromJson(e['actor']),
              List.from((e['video'] as List<dynamic>)
                  .map((e) => Vod.fromJson(e))
                  .toList()),
            ))
        .toList());
  }
}
