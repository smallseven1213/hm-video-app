import 'package:dio/dio.dart';
import 'package:shared/models/apk_update.dart';
import 'package:shared/services/system_config.dart';
import 'package:shared/utils/fetcher.dart';

final systemConfig = SystemConfig();

class DlApi {
  // 1: 不更新、2: 建議更新、3: 強制更新
  fetchDlJson() async {
    try {
      Future<Response> getResponse(
        List<String> apiList,
        Dio dio,
        RequestOptions options,
      ) async {
        List<Future<Response>> futures = [];
        for (String api in apiList) {
          futures.add(dio.get(api));
        }
        return await Future.any(futures);
      }

      Response response = await getResponse(
        systemConfig.vodHostList,
        Dio(),
        RequestOptions(),
      );
      var res = (response.data as Map<String, dynamic>);
      return res;
    } catch (err) {
      print('fetchDlJson error: $err');
    }
  }
}
