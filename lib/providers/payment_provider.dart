import 'package:flutter/foundation.dart';
import 'package:wgp_video_h5app/controllers/index.dart';
import 'package:wgp_video_h5app/helpers/index.dart';
import 'package:wgp_video_h5app/models/index.dart';
import 'package:wgp_video_h5app/providers/base_provider.dart';

class PaymentProvider extends BaseProvider {
  @override
  void onInit() {
    httpClient.baseUrl =
        '${AppController.cc.endpoint.getApi()}/public/payments';
    super.onInit();
  }

  Future<List<Payment>> getPaymentsBy(int productId) =>
      get('/channel/list?productId=$productId&deviceType=${kIsWeb ? 1 : isAndroid() ? 2 : 3}')
          .then((value) {
        var res = (value.body as Map<String, dynamic>);
        if (res['code'] != '00') {
          return [];
        }
        return List.from(
            (res['data'] as List<dynamic>).map((e) => Payment.fromJson(e)));
      });
}
