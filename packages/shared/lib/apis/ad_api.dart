import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../controllers/system_config_controller.dart';
import '../models/channel_banner.dart';
import '../models/video_ads.dart';
import '../utils/fetcher.dart';

final logger = Logger();

class AdApi {
  static final AdApi _instance = AdApi._internal();

  AdApi._internal();

  factory AdApi() {
    return _instance;
  }

  final SystemConfigController _systemConfigController =
      Get.find<SystemConfigController>();

  String get apiHost => _systemConfigController.apiHost.value!;

  Future<ChannelBanner> getBannersByChannel(int channelId) async {
    var res = await fetcher(
        url:
            '$apiHost/public/banners/banner/channelBanner?channelId=$channelId');
    if (res.data['code'] != '00') {
      return ChannelBanner(
        [],
        [],
      );
    }
    return ChannelBanner.fromJson(res.data['data']);
  }

  Future<VideoAds> getVideoPageAds() async {
    var res =
        await fetcher(url: '$apiHost/public/banners/banner/playingPosition');
    if (res.data['code'] != '00') {
      throw Exception('Error fetching video page ads: ${res.data['message']}');
    }
    return VideoAds.fromJson(res.data['data']);
  }
}
