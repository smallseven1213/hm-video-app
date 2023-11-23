import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared/apis/ad_api.dart';
import 'package:shared/models/short_video_ads.dart';

class ShortVideoAdsController extends GetxController {
  final AdApi adApi = AdApi();
  int videoViews = 0;
  bool isFetched = false;
  var videoAds =
      ShortVideoAds(bannerParamConfig: BannerParamConfig(config: [20, 20, 30]))
          .obs;
  // GetStorage box = GetStorage();
  // var entryCount = 0;

  @override
  void onInit() async {
    super.onInit();
    // entryCount = box.read('entry-count') ?? 0;
    if (isFetched == false) {
      init();
    }
  }

  Future<void> init() async {
    try {
      ShortVideoAds res = await adApi.getShortVideoPageAds();
      videoAds.value = res;
      isFetched = true;
    } catch (error) {
      logger.i(error);
    }
  }

  // // 紀錄觀看次數
  // void recordVideoViews() {
  //   videoViews = videoViews + 1;
  // }
}
