import 'package:dio/dio.dart';
import 'package:shared/models/banner.dart';
import 'package:shared/services/system_config.dart';
import 'package:shared/utils/fetcher.dart';

final systemConfig = SystemConfig();
String apiPrefix = '${systemConfig.apiHost}/public/banners';
final dio = Dio();

class BannerApi {
  // 取得banner by id
  Future<List<BannerPhoto>> getBannerById({
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
}
