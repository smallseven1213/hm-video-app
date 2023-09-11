import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/auth_controller.dart';

import '../apis/product_api.dart';
import '../models/product.dart';

final ProductApi productApi = ProductApi();
final logger = Logger();

class ProductController extends GetxController {
  var productList = <Product>[].obs;

  ProductController({required type}) {
    _fetchData(type);
    Get.find<AuthController>().token.listen((event) {
      _fetchData(type);
    });
  }

  _fetchData(type) async {
    var res = await productApi.getManyBy(type: type);
    productList.value = res;
  }
}
