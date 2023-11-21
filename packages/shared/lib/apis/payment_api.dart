import 'package:get/get.dart';

import '../controllers/system_config_controller.dart';
import '../models/payment.dart';
import '../utils/fetcher.dart';

class PaymentApi {
  static final PaymentApi _instance = PaymentApi._internal();

  PaymentApi._internal();

  factory PaymentApi() {
    return _instance;
  }

  final SystemConfigController _systemConfigController =
      Get.find<SystemConfigController>();

  String get apiHost => _systemConfigController.apiHost.value!;
  String get apiPrefix => '$apiHost/public/payments';

// deviceType=2 代表是app端 3代表是web端
  Future<List<Payment>> getPaymentsBy(int productId) async {
    var res = await fetcher(
        url: '$apiPrefix/channel/list?productId=$productId&deviceType=2');
    if (res.data['code'] != '00') {
      return [];
    }
    return List.from(
        (res.data['data'] as List<dynamic>).map((e) => Payment.fromJson(e)));
  }

  Future<Payment> getPaymentById(int id) async {
    var res = await fetcher(url: '$apiPrefix/payment?id=$id');
    if (res.data['code'] != '00') {
      return Payment(0, '');
    }
    return Payment.fromJson(res.data['data']);
  }
}
