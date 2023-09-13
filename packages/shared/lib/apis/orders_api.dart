import 'package:shared/models/user_order.dart';
import 'package:shared/services/system_config.dart';
import 'package:shared/utils/fetcher.dart';

final systemConfig = SystemConfig();

class OrderApi {
  static final OrderApi _instance = OrderApi._internal();

  OrderApi._internal();

  factory OrderApi() {
    return _instance;
  }

  Future<String> makeOrder({
    String agentAccount = '',
    required int productId,
    required int paymentChannelId,
    String? name,
  }) async {
    var value = await fetcher(
      url: '${systemConfig.apiHost}/public/orders/order',
      method: 'POST',
      body: {
        'name': name,
        'productId': productId,
        'paymentChannelId': paymentChannelId,
      },
    );
    var res = (value.data as Map<String, dynamic>);
    if (res['code'] != '00') {
      return res['code'];
    }
    return res['data']['paymentLink'];
  }

  Future<List<Order>> getManyBy({
    int page = 1,
    int limit = 20,
    int? paymentStatus = 0,
    int type = 1,
    String? startedAt,
    String? endedAt,
  }) async {
    var url =
        '${systemConfig.apiHost}/public/orders/order/record?type=$type&page=$page&limit=$limit';
    if (paymentStatus != null) {
      url += '&paymentStatus=$paymentStatus';
    }
    if (startedAt != null) {
      url += '&startedAt=$startedAt';
    }
    if (endedAt != null) {
      url += '&endedAt=$endedAt';
    }
    var value = await fetcher(url: url);
    var res = (value.data as Map<String, dynamic>);
    if (res['code'] != '00') {
      return [];
    }
    return List.from(
        (res['data']['data'] as List<dynamic>).map((e) => Order.fromJson(e)));
  }
}
