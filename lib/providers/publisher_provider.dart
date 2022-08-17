import 'package:wgp_video_h5app/controllers/index.dart';
import 'package:wgp_video_h5app/models/index.dart';
import 'package:wgp_video_h5app/providers/index.dart';

class PublisherProvider extends BaseProvider {
  @override
  void onInit() {
    httpClient.baseUrl =
        '${AppController.cc.endpoint.getApi()}/public/publishers';
    super.onInit();
  }

  Future<List<Publisher>> getManyBy(
          {required int page, String? name, int? sortBy}) =>
      get('/publisher/list?page=$page&limit=48&name=$name&isSortByVideos=${sortBy ?? 0}')
          .then((value) {
        // print(value.body);
        var res = (value.body as Map<String, dynamic>);
        // var total = res['data']['total'];
        if (res['code'] != '00') {
          return [];
        }
        return List.from((res['data']['data'] as List<dynamic>)
            .map((e) => Publisher.fromJson(e)));
      });

  Future<Publisher> getOne(int publisherId) =>
      get('/publisher?id=$publisherId').then((value) {
        // print(value.body);
        var res = (value.body as Map<String, dynamic>);
        if (res['code'] != '00') {
          return Publisher(0, '出版商', '');
        }
        return Publisher.fromJson(res['data']);
      });

  Future<BlockVod> getManyLatestVodBy(
          {int page = 1, int limit = 10, required int publisherId}) =>
      get('/publisher/latest?id=$publisherId&page=$page&limit=$limit')
          .then((value) {
        var res = (value.body as Map<String, dynamic>);
        if (res['code'] != '00') {
          return BlockVod([], 0);
        }
        // print(List.from((res['data'] as List<dynamic>).map((e) {
        //   try {
        //     return Vod.fromJson(e);
        //   } catch (ee) {
        //     print('err');
        //     print(ee);
        //   }
        // }).toList()));

        return BlockVod(
            List.from((res['data']['data'] as List<dynamic>)
                .map((e) => Vod.fromJson(e))
                .toList()),
            res['data']['total'] ?? limit * (page + 1));
      });
  Future<BlockVod> getManyHottestVodBy(
          {int page = 1, int limit = 10, required int publisherId}) =>
      get('/publisher/hottest?id=$publisherId&page=$page&limit=$limit')
          .then((value) {
        var res = (value.body as Map<String, dynamic>);
        if (res['code'] != '00') {
          return BlockVod([], 0);
        }
        // print(List.from((res['data'] as List<dynamic>).map((e) {
        //   try {
        //     return Vod.fromJson(e);
        //   } catch (ee) {
        //     print('err');
        //     print(ee);
        //   }
        // }).toList()));

        return BlockVod(
            List.from((res['data']['data'] as List<dynamic>)
                .map((e) => Vod.fromJson(e))
                .toList()),
            res['data']['total'] ?? limit * (page + 1));
      });
}
