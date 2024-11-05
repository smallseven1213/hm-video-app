import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../controllers/system_config_controller.dart';
import '../models/ad.dart';
import '../utils/fetcher.dart';

final logger = Logger();

class AdsApi {
  static final AdsApi _instance = AdsApi._internal();

  AdsApi._internal();

  factory AdsApi() {
    return _instance;
  }

  final SystemConfigController _systemConfigController =
      Get.find<SystemConfigController>();

  String get apiPrefix =>
      "${_systemConfigController.apiHost.value!}/api/v1";

  Future<List<Ads>> getManyBy({
    int page = 1,
    int limit = 20,
  }) async {
    var value = await fetcher(
        url:
            '$apiPrefix/ads-app?page=$page&limit=$limit&isRecommend=false');
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
            '$apiPrefix/ads-app?page=$page&limit=$limit&isRecommend=true');
    var res = (value.data as Map<String, dynamic>);

    if (res['code'] != '00') {
      return [];
    }
    return List.from(
        (res['data']['data'] as List<dynamic>).map((e) => Ads.fromJson(e)));
  }

  Future<void> addBannerClickRecord(int adsAppId) async {
    if (adsAppId == 0) return;
    fetcher(
        url: '$apiPrefix/ads-app/adsAppClickRecord',
        method: 'POST',
        body: {'adsAppId': adsAppId});
  }
}
