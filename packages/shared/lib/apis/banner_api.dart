import 'package:dio/dio.dart';
import 'package:shared/services/system_config.dart';
import 'package:shared/utils/fetcher.dart';

final systemConfig = SystemConfig();
String apiPrefix = '${systemConfig.apiHost}/public/banners';
final dio = Dio();

class BannerApi {
  // 取得banner by id
  Future<List> getBannerById({
    required int positionId,
  }) async {
    try {
      var response = await fetcher(
          url: '$apiPrefix/banner/position?positionId=$positionId');
      // var response =
      //     await dio.get('$apiPrefix/banner/position?positionId=$positionId');
      // var response =
      //     await dio.request('$apiPrefix/banner/position?positionId=$positionId',
      //         options: Options(
      //           method: 'GET',
      //         ));
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
