import 'package:shared/controllers/system_config_controller.dart';
import 'package:get/get.dart';

import '../controllers/live_system_controller.dart';
import '../models/ad.dart';
import '../utils/live_fetcher.dart';

class AdApi {
  static final AdApi _instance = AdApi._internal();
  SystemConfigController systemController = Get.find<SystemConfigController>();

  AdApi._internal();

  factory AdApi() {
    return _instance;
  }

  Future<List<Ad>> getBanners() async {
    final liveApiHost = Get.find<LiveSystemController>().liveApiHostValue;
    var response = await liveFetcher(
      url: '$liveApiHost/user/v1/ad/slots',
    );

    List<Ad> ads = (response.data['data'][0]['ads'] as List)
        .map((item) => Ad.fromJson(item))
        .toList();

    return ads;
  }

  // post recordAdClick
  Future<void> recordAdClick(int id) async {
    await liveFetcher(
      url: 'https://live-api.hmtech-dev.com/user/v1/ad/click',
      method: 'POST',
      body: {
        'id': id,
      },
    );
  }
}
