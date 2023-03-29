/**
 * 櫥窗用的Ad管理
 * AdWindowController, init will call AdApi().getBannersByChannel
 * and save to obs value
 */

import 'package:get/get.dart';
import 'package:shared/apis/ad_api.dart';
import 'package:shared/models/index.dart';

import '../models/channel_banner.dart';

class AdWindowController extends GetxController {
  var data = ChannelBanner([], []).obs;

  @override
  void onInit() async {
    super.onInit();
    fetchBanner();
  }

  Future<void> fetchBanner() async {
    AdApi adApi = AdApi();
    var result = await adApi.getBannersByChannel(3);
    var channelBanner = ChannelBanner(
      result.channelBanners,
      result.areaBanners,
      areaAdsHorizontal: result.areaAdsHorizontal,
      areaAdsVertical: result.areaAdsVertical,
    );
    data.value = channelBanner;
  }
}
