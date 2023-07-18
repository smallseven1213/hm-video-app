import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/auth_controller.dart';

import '../apis/supplier_api.dart';
import '../models/supplier_with_vods.dart';

final SupplierApi supplierApi = SupplierApi();
final logger = Logger();

class SupplierPopularController extends GetxController {
  var actors = <SupplierWithVod>[].obs;
  var isLoading = false.obs;
  var isError = false.obs;

  SupplierPopularController() {
    fetchData();
    Get.find<AuthController>().token.listen((event) {
      fetchData();
    });
  }

  fetchData() async {
    try {
      isLoading.value = true;
      isError.value = false;
      var res = await supplierApi.getManyPopularActorBy(
        page: 1,
        limit: 10,
      );
      actors.value = res;
    } catch (e) {
      isError.value = true;
    } finally {
      isLoading.value = false;
    }
  }
}
