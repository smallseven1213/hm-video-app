import 'package:shared/services/system_config.dart';
import '../models/payment.dart';
import '../utils/fetcher.dart';

final systemConfig = SystemConfig();
String apiPrefix = '${systemConfig.apiHost}/public/payments';

class PaymentApi {
  static final PaymentApi _instance = PaymentApi._internal();

  PaymentApi._internal();

  factory PaymentApi() {
    return _instance;
  }
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
