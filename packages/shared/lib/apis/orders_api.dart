import 'package:get/get.dart';
import 'package:shared/models/user_order.dart';
import 'package:shared/utils/fetcher.dart';

import '../controllers/system_config_controller.dart';

class OrderApi {
  static final OrderApi _instance = OrderApi._internal();

  OrderApi._internal();

  factory OrderApi() {
    return _instance;
  }

  final SystemConfigController _systemConfigController =
      Get.find<SystemConfigController>();

  String get apiHost => _systemConfigController.apiHost.value!;

  Future<Map> makeOrder({
    String agentAccount = '',
    required int productId,
    required int paymentChannelId,
    String? name,
  }) async {
    var value = await fetcher(
      url: '$apiHost/api/v1/order',
      method: 'POST',
      body: {
        'name': name,
        'productId': productId,
        'paymentChannelId': paymentChannelId,
      },
    );
    var res = (value.data as Map<String, dynamic>);
    if (res['code'] != '00') {
      return res;
    }
    return res;
  }

  Future<List<Order>> getManyBy({
    int page = 1,
    int limit = 20,
    int? paymentStatus,
    String? type,
    String? startedAt,
    String? endedAt,
  }) async {
    var url = '$apiHost/api/v1/order?page=$page&limit=$limit';
    if (paymentStatus != null) {
      url += '&paymentStatus=$paymentStatus';
    }
    if (startedAt != null) {
      url += '&startedAt=$startedAt';
    }
    if (endedAt != null) {
      url += '&endedAt=$endedAt';
    }
    if (type != null && type.isNotEmpty) {
      url += '&type=$type';
    }
    var value = await fetcher(url: url);
    var res = (value.data as Map<String, dynamic>);
    if (res['code'] != '00') {
      return [];
    }

    // return List.from(([
    //   {
    //     'id': '123213213213',
    //     'orderAmount': '212',
    //     'paymentStatus': 0,
    //     'createdAt': '2021-09-30T07:00:00.000Z',
    //     'product': {
    //       'balanceFiatMoneyPrice': "200.00",
    //       'bundles': [],
    //       'colorHex': null,
    //       'description': "VIP視頻永久無限看",
    //       'fiatMoneyPrice': "1288.00",
    //       'id': 10,
    //       'name': "「巨划算」永久观影卡",
    //       'photoSid': "d5196f60-912d-49b4-8fe0-972da1cfb55a",
    //       'subTitle': null,
    //       'type': 2,
    //       'vipDays': 9999
    //     }
    //   },
    // ] as List<dynamic>)
    //     .map((e) => Order.fromJson(e)));
    return List.from(
        (res['data']['items'] as List<dynamic>).map((e) => Order.fromJson(e)));
  }
}
