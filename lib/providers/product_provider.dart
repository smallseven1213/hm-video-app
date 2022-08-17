import 'package:wgp_video_h5app/controllers/index.dart';
import 'package:wgp_video_h5app/models/index.dart';
import 'package:wgp_video_h5app/providers/base_provider.dart';

class ProductProvider extends BaseProvider {
  @override
  void onInit() {
    httpClient.baseUrl =
        '${AppController.cc.endpoint.getApi()}/public/products';
    super.onInit();
  }

  Future<List<Product>> getManyBy(
          {int type = 1, int page = 1, int limit = 100}) =>
      get('/product/list?page=$page&limit=$limit&type=$type').then((value) {
        // print('$region, $page, $sortBy, $name');
        var res = (value.body as Map<String, dynamic>);
        // var total = res['data']['total'];
        // print((res['data']['data'] as List<dynamic>).length);
        if (res['code'] != '00') {
          return [];
        }
        return List.from((res['data']['data'] as List<dynamic>)
            .map((e) => Product.fromJson(e)));
      });

  Future<Product> getOne(int id) => get('/product?id=$id').then((value) {
        // print(value.body);
        var res = (value.body as Map<String, dynamic>);
        if (res['code'] != '00') {
          return Product();
        }
        return Product.fromJson(res['data']);
      });
}
