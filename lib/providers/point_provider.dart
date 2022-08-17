import 'package:wgp_video_h5app/controllers/index.dart';
import 'package:wgp_video_h5app/models/index.dart';
import 'package:wgp_video_h5app/providers/index.dart';

class PointProvider extends BaseProvider {
  @override
  void onInit() {
    httpClient.baseUrl = '${AppController.cc.endpoint.getApi()}/public/points';
    super.onInit();
  }

  Future<BlockVod> getManyBy() =>
      get('/purchase-record/list/video').then((value) {
        var res = (value.body as Map<String, dynamic>);
        // var total = res['data']['total'];
        // print((res['data']['data'] as List<dynamic>).length);
        if (res['code'] != '00') {
          return BlockVod([], 0);
        }
        List<Vod> vods = List.from(
            (res['data'] as List<dynamic>).map((e) => Vod.fromJson(e)));
        return BlockVod(
          vods,
          vods.length,
        );
      });
  Future<List<UserPointRecord>> getPoints({int limit = 100, int page = 1}) =>
      get('/purchase-record/list?page=$page&limit=$limit').then((value) {
        var res = (value.body as Map<String, dynamic>);
        if (res['code'] != '00') {
          return [];
        }
        return List.from((res['data']['data'] as List<dynamic>)
            .map((e) => UserPointRecord.fromJson(e)));
      });
}
