import 'package:wgp_video_h5app/controllers/index.dart';
import 'package:wgp_video_h5app/models/index.dart';
import 'package:wgp_video_h5app/providers/index.dart';

class OrderProvider extends BaseProvider {
  @override
  void onInit() {
    httpClient.timeout = const Duration(minutes: 1);
    httpClient.baseUrl = '${AppController.cc.endpoint.getApi()}/public/orders';
    super.onInit();
  }

  Future<String> makeOrder({
    String agentAccount = '',
    required int productId,
    required int paymentChannelId,
  }) async {
    var value = await post(
      '/order',
      {
        'productId': productId,
        'paymentChannelId': paymentChannelId,
      },
    );
    var res = (value.body as Map<String, dynamic>);
    // print({
    //   'res': res,
    //   'productId': productId,
    //   'paymentChannelId': paymentChannelId
    // });
    if (res['code'] != '00') {
      return '';
    }
    return res['data']['paymentLink'];
  }

  Future<List<Order>> getManyBy({
    int page = 1,
    int limit = 20,
    required String userId,
    int paymentStatus = 0,
    int type = 1,
  }) async {
    var value = await get(
        '/order/record?type=$type&page=$page&limit=$limit${paymentStatus > 0 ? '&paymentStatus=$paymentStatus' : ''}');
    var res = (value.body as Map<String, dynamic>);
    if (res['code'] != '00') {
      return [];
    }
    // print(paymentStatus);
    return List.from(
        (res['data']['data'] as List<dynamic>).map((e) => Order.fromJson(e)));
  }
}
