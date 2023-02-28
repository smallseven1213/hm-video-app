import '../models/product.dart';
import '../utils/fetcher.dart';

class ProductProvider {
  Future<List<Product>> getManyBy(
      {int type = 1, int page = 1, int limit = 100}) async {
    var res =
        await fetcher(url: '/product/list?page=$page&limit=$limit&type=$type');
    if (res.data['code'] != '00') {
      return [];
    }
    return List.from((res.data['data']['data'] as List<dynamic>)
        .map((e) => Product.fromJson(e)));
  }

  Future<Product> getOne(int id) async {
    var res = await fetcher(url: '/product?id=$id');
    if (res.data['code'] != '00') {
      return Product();
    }
    return Product.fromJson(res.data['data']);
  }
}
