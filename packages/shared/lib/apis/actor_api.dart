import 'package:logger/logger.dart';

import '../models/actor.dart';
import '../models/actor_with_vods.dart';
import '../models/block_vod.dart';
import '../models/vod.dart';
import '../services/system_config.dart';
import '../utils/fetcher.dart';

final systemConfig = SystemConfig();
String apiPrefix = '${systemConfig.apiHost}/public/actors';

final logger = Logger();

class ActorApi {
  Future<List<Actor>> getManyBy({
    required int page,
    int limit = 100,
    String? name,
    int? sortBy,
    required int region,
  }) async {
    var res = await fetcher(
        url:
            '$apiPrefix/actor/list?page=$page&limit=$limit&name=$name&region=$region&isSortByVideos=${sortBy ?? 0}');
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
            '$apiPrefix/actor/list?page=$page&limit=48&name=$name&isSortByVideos=0');
    if (res.data['code'] != '00') {
      return [];
    }
    return List.from((res.data['data']['data'] as List<dynamic>)
        .map((e) => Actor.fromJson(e)));
  }

  Future<Actor> getOne(int actorId) async {
    var res = await fetcher(url: '$apiPrefix/actor?id=$actorId');
    if (res.data['code'] != '00') {
      return Actor(0, '演員', '');
    }
    return Actor.fromJson(res.data['data']);
  }

  Future<BlockVod> getManyLatestVodBy(
      {int page = 1, int limit = 10, required int actorId}) async {
    var res = await fetcher(
        url: '$apiPrefix/actor/latest?id=$actorId&page=$page&limit=$limit');
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
        url: '$apiPrefix/actor/hottest?id=$actorId&page=$page&limit=$limit');
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
        url: '$apiPrefix/actor/popular-actor-channel?page=$page&limit=$limit');
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
