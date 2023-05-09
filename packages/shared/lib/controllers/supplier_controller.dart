import 'package:get/get.dart';

import '../apis/supplier_api.dart';
import '../models/supplier.dart';

final supplierApi = SupplierApi();

class SupplierController extends GetxController {
  Rx<Supplier?> supplier = null.obs;
  int supplierId;

  SupplierController({required this.supplierId}) {
    _fetchData();
  }

  _fetchData() async {
    var res = await supplierApi.getOneSupplier(supplierId);
    supplier.value = res;
  }
}
