import 'package:wgp_video_h5app/controllers/index.dart';
import 'package:wgp_video_h5app/models/bundling_product.dart';
import 'package:wgp_video_h5app/providers/base_provider.dart';

class BundlingProductProvider extends BaseProvider {
  @override
  void onInit() {
    httpClient.baseUrl =
        '${AppController.cc.endpoint.getApi()}/public/bundlingProducts';
    super.onInit();
  }

  Future<List<BundlingProduct>> getManyBy({int page = 1, int limit = 100}) =>
      get('/bundlingProduct/list').then((value) {
        // print('$region, $page, $sortBy, $name');
        var res = (value.body as Map<String, dynamic>);
        // var total = res['data']['total'];
        // print((res['data']['data'] as List<dynamic>).length);
        if (res['code'] != '00') {
          return [];
        }
        return List.from((res['data']['data'] as List<dynamic>)
            .map((e) => BundlingProduct.fromJson(e)));
      });

  Future<BundlingProduct> getOne(int id) =>
      get('/bundlingProduct?id=$id').then((value) {
        // print(value.body);
        var res = (value.body as Map<String, dynamic>);
        if (res['code'] != '00') {
          return BundlingProduct(0);
        }
        return BundlingProduct.fromJson(res['data']);
      });
}
