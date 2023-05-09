import '../models/supplier.dart';
import '../models/vod.dart';
import '../services/system_config.dart';
import '../utils/fetcher.dart';

final systemConfig = SystemConfig();
String apiPrefix = '${systemConfig.apiHost}/public/suppliers';

class SupplierApi {
  static final SupplierApi _instance = SupplierApi._internal();

  SupplierApi._internal();

  factory SupplierApi() {
    return _instance;
  }

  // Get suppliers/supplier/?id=20 By id
  Future<Supplier> getOneSupplier(int id) async {
    var res = await fetcher(url: '$apiPrefix/supplier/?id=$id');
    if (res.data['code'] != '00') {
      return Supplier(0, '');
    }
    return Supplier.fromJson(res.data['data']);
  }

  // Get /supplier/shortVideo?page=1&limit=100&id=20
  Future<List<Vod>> getManyShortVideoBy({
    required int page,
    int limit = 100,
    required int id,
  }) async {
    var res = await fetcher(
        url: '$apiPrefix/supplier/shortVideo?page=$page&limit=$limit&id=$id');
    if (res.data['code'] != '00') {
      return [];
    }
    return List.from((res.data['data']['data'] as List<dynamic>)
        .map((e) => Vod.fromJson(e)));
  }
}
