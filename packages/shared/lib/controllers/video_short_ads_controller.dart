import 'package:get/get.dart';
import 'package:shared/apis/ad_api.dart';
// import 'package:shared/models/short_video_ads.dart';

import '../models/video_ads.dart';

class ShortVideoAdsController extends GetxController {
  final AdApi adApi = AdApi();
  bool isFetched = false;
  var videoAds =
      VideoAds(bannerParamConfig: BannerParamConfig(config: [20, 20, 30]))
          .obs;

  @override
  void onInit() async {
    super.onInit();
    if (isFetched == false) {
      init();
    }
  }

  Future<void> init() async {
    try {
      VideoAds res = await adApi.getVideoPageAds();
      videoAds.value = res;
      isFetched = true;
    } catch (error) {
      logger.i(error);
    }
  }
}

