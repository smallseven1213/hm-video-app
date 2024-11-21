import 'package:get/get.dart';
import 'package:shared/utils/fetcher.dart';

import '../controllers/system_config_controller.dart';
import '../models/banner_photo.dart';

class BannerApi {
  static final BannerApi _instance = BannerApi._internal();

  BannerApi._internal();

  factory BannerApi() {
    return _instance;
  }

  final SystemConfigController _systemConfigController =
      Get.find<SystemConfigController>();

  String get apiHost => _systemConfigController.apiHost.value!;
  String get apiPrefix => '$apiHost/api/v1';

  // 取得banner by id
  Future<List<BannerPhoto>> getBannerById({
    required int positionId,
  }) async {
    try {
      var response =
          await fetcher(url: '$apiPrefix/banner?positionId=$positionId');
      var res = (response.data as Map<String, dynamic>);
      if (res['code'] != '00') {
        return [];
      }

      var result = (res['data'] as List<dynamic>)
          .map((e) => BannerPhoto.fromJson(e as Map<String, dynamic>))
          .toList();

      logger.i('getBannerById: $result');
      return result;
    } catch (err) {
      logger.i('getBannerById error: $err');
      return [];
    }
  }

  // 紀錄點擊
  Future<void> recordBannerClick({
    required int bannerId,
  }) async {
    if (bannerId == 0) {
      throw Exception('bannerId is 0');
    }
    fetcher(url: '$apiPrefix/banner/bannerClickRecord', method: 'POST', body: {
      'bannerId': bannerId,
    });
  }
}
