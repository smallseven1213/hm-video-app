import 'package:get/get.dart';
import 'package:shared/apis/ad_api.dart';

import '../models/channel_banner.dart';

class AdWindowController extends GetxController {
  final int channelId;
  var data = ChannelBanner([], []).obs;

  AdWindowController(this.channelId);

  @override
  void onInit() async {
    super.onInit();
    fetchBanner(channelId);
  }

  Future<void> fetchBanner(int channelId) async {
    AdApi adApi = AdApi();
    var result = await adApi.getBannersByChannel(channelId);
    var channelBanner = ChannelBanner(
      result.channelBanners,
      result.areaBanners,
      areaAdsHorizontal: result.areaAdsHorizontal,
      areaAdsVertical: result.areaAdsVertical,
    );
    data.value = channelBanner;
  }
}
