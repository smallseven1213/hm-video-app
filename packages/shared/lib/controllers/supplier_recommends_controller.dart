import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/auth_controller.dart';

import '../apis/supplier_api.dart';
import '../models/supplier.dart';

final SupplierApi supplierApi = SupplierApi();
final logger = Logger();

class SupplierRecommendsController extends GetxController {
  var suppliers = <Supplier>[].obs;
  var isLoading = false.obs;
  var isError = false.obs;

  SupplierRecommendsController() {
    fetchData();
    Get.find<AuthController>().token.listen((event) {
      fetchData();
    });
  }

  fetchData() async {
    try {
      isLoading.value = true;
      isError.value = false;
      var res = await supplierApi.getManyBy(
          page: 1, limit: 10, isRecommend: true, sortBy: 1, name: "");
      suppliers.value = res;
    } catch (e) {
      isError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  removeSupplierById(int id) {
    var index = suppliers.indexWhere((supplier) => supplier.id == id);
    if (index != -1) {
      suppliers.removeAt(index);
    }
  }
}
