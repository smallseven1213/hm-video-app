import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/auth_controller.dart';

import '../apis/payment_api.dart';
import '../models/payment.dart';

final PaymentApi paymentApi = PaymentApi();
final logger = Logger();

class PaymentController extends GetxController {
  var payments = <Payment>[].obs;

  PaymentController({required productId}) {
    _fetchData(productId);
    Get.find<AuthController>().token.listen((event) {
      _fetchData(productId);
    });
  }

  _fetchData(productId) async {
    var res = await paymentApi.getPaymentsBy(productId);
    payments.value = res;
  }
}
