import 'package:shared/services/system_config.dart';
import 'package:shared/utils/fetcher.dart';

final systemConfig = SystemConfig();
String apiPrefix = '${systemConfig.apiHost}/public/banners';

class BannerApi {
  // 取得banner by id
  Future<List> getBannerById({
    required String positionId,
  }) async {
    try {
      var response = await fetcher(
          url: '$apiPrefix/banner/position?positionId=$positionId');
      var res = (response.data as Map<String, dynamic>);
      if (res['code'] != '00') {
        return [];
      }
      print('getBannerById: ${res['data']}');
      return res['data'];
    } catch (err) {
      print('getBannerById error: $err');
      return [];
    }
  }
}
