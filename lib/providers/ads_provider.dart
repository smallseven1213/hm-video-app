import 'package:flutter/cupertino.dart';
import 'package:wgp_video_h5app/controllers/index.dart';
import 'package:wgp_video_h5app/providers/index.dart';

import '../models/ads.dart';

class AdsProvider extends BaseProvider {
  @override
  void onInit() {
    httpClient.timeout = const Duration(minutes: 1);
    httpClient.baseUrl = '${AppController.cc.endpoint.getApi()}/public/ads-apps';
    super.onInit();
  }

  // Future<String> makeOrder({
  //   String agentAccount = '',
  //   required int productId,
  //   required int paymentChannelId,
  // }) async {
  //   var value = await post(
  //     '/order',
  //     {
  //       'productId': productId,
  //       'paymentChannelId': paymentChannelId,
  //     },
  //   );
  //   var res = (value.body as Map<String, dynamic>);
  //   // print({
  //   //   'res': res,
  //   //   'productId': productId,
  //   //   'paymentChannelId': paymentChannelId
  //   // });
  //   if (res['code'] != '00') {
  //     return '';
  //   }
  //   return res['data']['paymentLink'];
  // }

  Future<List<Ads>> getManyBy({
    int page = 1,
    int limit = 20,
  }) async {
    var value = await get(
        '/ads-app/list?page=$page&limit=$limit&isRecommend=false');
    var res = (value.body as Map<String, dynamic>);
    debugPrint('data: $res');
    if (res['code'] != '00') {
      return [];
    }
    // print((res['data']['data'] as List<dynamic>).map((e) => Ads.fromJson(e)));
    // print(List.from(
    //     (res['data']['data'] as List<dynamic>).map((e) => Ads.fromJson(e))));
    return List.from(
        (res['data']['data'] as List<dynamic>).map((e) => Ads.fromJson(e)));
  }

  Future<List<Ads>> getRecommendBy({
    int page = 1,
    int limit = 20,
  }) async {
    var value = await get(
        '/ads-app/list?page=$page&limit=$limit&isRecommend=true');
    var res = (value.body as Map<String, dynamic>);
    debugPrint('data: $res');
    if (res['code'] != '00') {
      return [];
    }
     print(List.from(
         (res['data']['data'] as List<dynamic>).map((e) => Ads.fromJson(e))));
    return List.from(
        (res['data']['data'] as List<dynamic>).map((e) => Ads.fromJson(e)));
  }
}
