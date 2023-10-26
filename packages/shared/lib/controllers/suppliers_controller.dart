import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../apis/supplier_api.dart';
import '../models/supplier.dart';

final SupplierApi supplierApi = SupplierApi();
final logger = Logger();

class SuppliersController extends GetxController {
  var actors = <Supplier>[].obs;
  Rx<int?> region = Rx<int?>(null);
  Rx<String?> name = Rx<String?>(null);
  Rx<int> sortBy = Rx<int>(1);

  SuppliersController() {
    _fetchData();
  }

  // 提供给外部的方法，以改变name并重新获取数据
  void setName(String? newName) {
    name.value = newName;
    _fetchData();
  }

  // 提供给外部的方法，以改变sortBy并重新获取数据
  void setSortBy(int newSortBy) {
    sortBy.value = newSortBy;
    _fetchData();
  }

  // 提供给外部的方法，根据指定的index删除actors中的某一条数据
  void removeSupplierByIndex(int index) {
    if (index >= 0 && index < actors.length) {
      actors.removeAt(index);
    } else {
      logger.e("Index out of bounds: $index");
    }
  }

  _fetchData() async {
    var res = await supplierApi.getManyBy(
        page: 1,
        limit: 1000,
        name: name.value ?? '',
        sortBy: sortBy.value,
        isRecommend: false);
    actors.value = res;
  }
}
