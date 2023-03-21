import 'package:logger/logger.dart';

import '../models/ad.dart';
import '../services/system_config.dart';
import '../utils/fetcher.dart';

final logger = Logger();
final systemConfig = SystemConfig();
String apiPrefix = '${systemConfig.apiHost}/public/ads-apps';

class AdsApi {
  Future<List<Ads>> getManyBy({
    int page = 1,
    int limit = 20,
  }) async {
    logger.i('call me!');
    var value = await fetcher(
        url:
            '$apiPrefix/ads-app/list?page=$page&limit=$limit&isRecommend=false');
    var res = (value.data as Map<String, dynamic>);

    if (res['code'] != '00') {
      return [];
    }
    return List.from(
        (res['data']['data'] as List<dynamic>).map((e) => Ads.fromJson(e)));
  }

  Future<List<Ads>> getRecommendBy({
    int page = 1,
    int limit = 20,
  }) async {
    var value = await fetcher(
        url:
            '$apiPrefix/ads-app/list?page=$page&limit=$limit&isRecommend=true');
    var res = (value.data as Map<String, dynamic>);

    if (res['code'] != '00') {
      return [];
    }
    print(List.from(
        (res['data']['data'] as List<dynamic>).map((e) => Ads.fromJson(e))));
    return List.from(
        (res['data']['data'] as List<dynamic>).map((e) => Ads.fromJson(e)));
  }

  Future<void> addBannerClickRecord(int adsAppId) async {
    if (adsAppId == 0) return;
    fetcher(
        url: '$apiPrefix/ads-app/adsAppClickRecord',
        body: {'adsAppId': adsAppId});
  }
}
