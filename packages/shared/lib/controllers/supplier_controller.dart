import 'package:get/get.dart';

import '../apis/supplier_api.dart';
import '../models/supplier.dart';

final supplierApi = SupplierApi();

class SupplierController extends GetxController {
  Rx<Supplier> supplier = Supplier().obs;
  int supplierId;

  SupplierController({required this.supplierId}) {
    _fetchData();
  }

  _fetchData() async {
    var res = await supplierApi.getOneSupplier(supplierId);
    supplier.value = res;
  }

  void incrementTotal(String type) {
    if (type == 'follow') {
      supplier.value.followTotal = (supplier.value.followTotal ?? 0) + 1;
    } else if (type == 'collect') {
      supplier.value.collectTotal = (supplier.value.collectTotal ?? 0) + 1;
    }
    supplier.refresh();
  }

  void decrementTotal(String type) {
    if (type == 'follow') {
      int currentFollowTotal = supplier.value.followTotal ?? 0;
      supplier.value.followTotal =
          currentFollowTotal > 0 ? currentFollowTotal - 1 : 0;
    } else if (type == 'collect') {
      int currentCollectTotal = supplier.value.collectTotal ?? 0;
      supplier.value.collectTotal =
          currentCollectTotal > 0 ? currentCollectTotal - 1 : 0;
    }
    supplier.refresh();
  }
}
