import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../controllers/system_config_controller.dart';
import '../models/payment.dart';
import '../utils/fetcher.dart';

enum deviceType {
  none,
  web,
  ios,
  android,
}

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
        url:
            '$apiHost/api/v1/payment-channel?productId=$productId&deviceType=${kIsWeb ? deviceType.web.index : deviceType.android.index}');
    if (res.data['code'] != '00') {
      return [];
    }
    return List.from(
        (res.data['data'] as List<dynamic>).map((e) => Payment.fromJson(e)));
  }

  Future<Payment> getPaymentById(int id) async {
    var res = await fetcher(url: '$apiPrefix/payment?id=$id');
    if (res.data['code'] != '00') {
      return Payment(0, '', '');
    }
    return Payment.fromJson(res.data['data']);
  }
}
