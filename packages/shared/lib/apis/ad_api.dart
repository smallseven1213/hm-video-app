import 'package:logger/logger.dart';

import '../models/ad.dart';
import '../models/channel_banner.dart';
import '../models/video_ads.dart';
import '../services/system_config.dart';
import '../utils/fetcher.dart';

final logger = Logger();
final systemConfig = SystemConfig();
String apiPrefix = '${systemConfig.apiHost}/public/ads-apps';

class AdApi {
  Future<ChannelBanner> getBannersByChannel(int channelId) async {
    var res = await fetcher(
        url:
            '${systemConfig.apiHost}/public/banners/banner/channelBanner?channelId=$channelId');
    if (res.data['code'] != '00') {
      return ChannelBanner(
        [],
        [],
      );
    }
    return ChannelBanner.fromJson(res.data['data']);
  }

  Future<VideoAds> getVideoPageAds() async {
    var res = await fetcher(
        url: '${systemConfig.apiHost}/public/banners/banner/playingPosition');
    if (res.data['code'] != '00') {
      throw Exception('Error fetching video page ads: ${res.data['message']}');
    }
    return VideoAds.fromJson(res.data['data']);
  }
}
