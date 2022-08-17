import 'package:wgp_video_h5app/controllers/index.dart';
import 'package:wgp_video_h5app/models/index.dart';
import 'package:wgp_video_h5app/providers/index.dart';

class ActorProvider extends BaseProvider {
  @override
  void onInit() {
    httpClient.baseUrl = '${AppController.cc.endpoint.getApi()}/public/actors';
    super.onInit();
  }

  Future<List<Actor>> getManyBy({
    required int page,
    int limit = 100,
    String? name,
    int? sortBy,
    required int region,
  }) =>
      get('/actor/list?page=$page&limit=$limit&name=$name&region=$region&isSortByVideos=${sortBy ?? 0}')
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

  Future<List<Actor>> searchBy({
    required int page,
    String? name,
  }) =>
      get('/actor/list?page=$page&limit=48&name=$name&isSortByVideos=0')
          .then((value) {
        var res = (value.body as Map<String, dynamic>);
        // var total = res['data']['total'];
        // print((res['data']['data'] as List<dynamic>).length);
        if (res['code'] != '00') {
          return [];
        }
        return List.from((res['data']['data'] as List<dynamic>)
            .map((e) => Actor.fromJson(e)));
      });

  Future<Actor> getOne(int actorId) => get('/actor?id=$actorId').then((value) {
        // print(value.body);
        var res = (value.body as Map<String, dynamic>);
        if (res['code'] != '00') {
          return Actor(0, '演員', '');
        }
        return Actor.fromJson(res['data']);
      });

  Future<BlockVod> getManyLatestVodBy(
          {int page = 1, int limit = 10, required int actorId}) =>
      get('/actor/latest?id=$actorId&page=$page&limit=$limit').then((value) {
        var res = (value.body as Map<String, dynamic>);
        if (res['code'] != '00') {
          return BlockVod([], 0);
        }
        return BlockVod(
          List.from((res['data']['data'] as List<dynamic>)
              .map((e) => Vod.fromJson(e))
              .toList()),
          res['data']['total'],
        );
      });
  Future<BlockVod> getManyHottestVodBy(
          {int page = 1, int limit = 10, required int actorId}) =>
      get('/actor/hottest?id=$actorId&page=$page&limit=$limit').then((value) {
        var res = (value.body as Map<String, dynamic>);
        if (res['code'] != '00') {
          return BlockVod([], 0);
        }
        return BlockVod(
          List.from((res['data']['data'] as List<dynamic>)
              .map((e) => Vod.fromJson(e))
              .toList()),
          res['data']['total'],
        );
      });
}
