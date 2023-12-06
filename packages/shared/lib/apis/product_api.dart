import 'package:get/get.dart';

import '../controllers/system_config_controller.dart';
import '../models/product.dart';
import '../utils/fetcher.dart';

class ProductApi {
  static final ProductApi _instance = ProductApi._internal();

  ProductApi._internal();

  factory ProductApi() {
    return _instance;
  }

  final SystemConfigController _systemConfigController =
      Get.find<SystemConfigController>();

  String get apiHost => _systemConfigController.apiHost.value!;
  String get apiPrefix => '$apiHost/public/products';

  // VIP列表、金幣列表 type: 1-金幣包 2-VIP
  Future<List<Product>> getManyBy(
      {int type = 1, int page = 1, int limit = 100}) async {
    var res = await fetcher(
        url: '$apiPrefix/product/list?page=$page&limit=$limit&type=$type');
    if (res.data['code'] != '00') {
      return [];
    }
    return List.from((res.data['data']['data'] as List<dynamic>)
        .map((e) => Product.fromJson(e)));
  }

  Future<Product> getOne(int id) async {
    var res = await fetcher(url: '/product?id=$id');
    if (res.data['code'] != '00') {
      return Product(id: 0);
    }
    return Product.fromJson(res.data['data']);
  }
}
