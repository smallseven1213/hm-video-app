import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/auth_controller.dart';

import '../apis/orders_api.dart';
import '../models/user_order.dart';

final OrderApi orderApi = OrderApi();
final logger = Logger();

class UserOrderController extends GetxController {
  var orderRecord = <Order>[].obs;

  UserOrderController({required String type}) {
    _fetchData(type);
    Get.find<AuthController>().token.listen((event) {
      _fetchData(type);
    });
  }

  _fetchData(type) async {
    var res = await orderApi.getManyBy(type: type);
    orderRecord.value = res;
  }
}
