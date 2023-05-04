import 'package:get/get.dart';
import 'package:shared/apis/ad_api.dart';
import 'package:shared/services/system_config.dart';
import '../models/video_ads.dart';

final systemConfig = SystemConfig();

class VideoAdsController extends GetxController {
  final AdApi adApi = AdApi();
  int videoViews = 0;
  bool isFetched = false;
  var videoAds =
      VideoAds(bannerParamConfig: BannerParamConfig(config: [20, 20, 30])).obs;
  final entryCount = systemConfig.box.read('entry-count') ?? 0;

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
      print(error);
    }
  }

  // 紀錄觀看次數
  void recordVideoViews() {
    videoViews = videoViews + 1;
  }
}
