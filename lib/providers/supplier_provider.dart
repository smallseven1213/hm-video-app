import 'package:wgp_video_h5app/controllers/index.dart';
import 'package:wgp_video_h5app/models/index.dart';
import 'package:wgp_video_h5app/providers/index.dart';

import '../models/pager.dart';

class SupplierProvider extends BaseProvider {
  @override
  void onInit() {
    httpClient.baseUrl = '${AppController.cc.endpoint.getApi()}/public/suppliers';
    super.onInit();
  }

  Future<Supplier> getOne(int id) =>
      get('/supplier/?id=$id').then((value) {
        // print(value.body);
        var res = (value.body as Map<String, dynamic>);
        if (res['code'] != '00') {
          return Supplier(0, 'guest');
        }
        return Supplier.fromJson(res['data']);
      });

  Future<Pager<Supplier>> getManyBy({
    required int page,
    required int limit,
    required int id,
  }) =>
      get('/supplier/shortVideo?page=$page&limit=$limit&id=$id')
          .then((value) {
        // print('$region, $page, $sortBy, $name');
        var res = (value.body as Map<String, dynamic>);
        if (res['code'] != '00') {
          return Future.delayed(Duration.zero);
        }
        return Pager.fromJson(res['data'], List.from((res['data']['data'] as List<dynamic>)
            .map((e) => Supplier.fromJson(e))));
      });

  Future<SupplierVideos> getPlayList({
    required int supplierId,
    required int videoId,
  }) =>
      get('/supplier/playlist?supplierId=$supplierId&videoId=$videoId')
          .then((value) {
        // print('$region, $page, $sortBy, $name');
        var res = (value.body as Map<String, dynamic>);
        if (res['code'] != '00') {
          return Future.delayed(Duration.zero);
        }
        return SupplierVideos.fromJson(res['data'][0]);
      });
}


