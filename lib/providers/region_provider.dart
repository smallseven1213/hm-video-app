import 'package:wgp_video_h5app/controllers/index.dart';
import 'package:wgp_video_h5app/models/index.dart';
import 'package:wgp_video_h5app/providers/index.dart';

class RegionProvider extends BaseProvider {
  @override
  void onInit() {
    httpClient.baseUrl = '${AppController.cc.endpoint.getApi()}/public/regions';
    super.onInit();
  }

  Future<List<Region>> getManyBy({
    required int page,
    int limit = 100,
  }) =>
      get('/region/list?page=$page&limit=$limit').then((value) {
        // print(value.body);
        var res = (value.body as Map<String, dynamic>);
        // var total = res['data']['total'];
        if (res['code'] != '00') {
          return [];
        }
        return List.from((res['data']['data'] as List<dynamic>)
            .map((e) => Region.fromJson(e)));
      });

  Future<Region> getOne(int regionId) =>
      get('/region?id=$regionId').then((value) {
        // print(value.body);
        var res = (value.body as Map<String, dynamic>);
        if (res['code'] != '00') {
          return Region(0, '地區');
        }
        return Region.fromJson(res['data']);
      });
}
