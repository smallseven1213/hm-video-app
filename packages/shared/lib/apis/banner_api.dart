import 'package:dio/dio.dart';
import 'package:shared/models/banner.dart';
import 'package:shared/services/system_config.dart';
import 'package:shared/utils/fetcher.dart';

final systemConfig = SystemConfig();
String apiPrefix = '${systemConfig.apiHost}/public/banners';

class BannerApi {
  // 取得banner by id
  Future<List<BannerPhoto>> getBannerById({
    required int positionId,
  }) async {
    try {
      var response = await fetcher(
          url: '$apiPrefix/banner/position?positionId=$positionId');
      var res = (response.data as Map<String, dynamic>);
      if (res['code'] != '00') {
        return [];
      }

      var result = (res['data'] as List<dynamic>)
          .map((e) => BannerPhoto.fromJson(e as Map<String, dynamic>))
          .toList();

      print('getBannerById: $result');
      return result;
    } catch (err) {
      print('getBannerById error: $err');
      return [];
    }
  }

  // 紀錄點擊
  Future<void> recordBannerClick({
    required int bannerId,
  }) async {
    try {
      var response = await fetcher(
          url: '$apiPrefix/banner/bannerClickRecord',
          method: 'POST',
          body: {'bannerId': bannerId});
      var res = (response.data as Map<String, dynamic>);
      if (res['code'] != '00') {
        return;
      }
    } catch (err) {
      print('recordBannerClick error: $err');
    }
  }
}
