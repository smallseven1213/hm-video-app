import 'dart:async';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:shared/services/system_config.dart';

final systemConfig = SystemConfig();
final logger = Logger();

class DlApi {
  static final DlApi _instance = DlApi._internal();

  DlApi._internal();

  factory DlApi() {
    return _instance;
  }

  // 1: 不更新、2: 建議更新、3: 強制更新

  fetchDlJson() async {
    try {
      Future<Response> getResponse(
        List<String> apiList,
        Dio dio,
      ) async {
        var completer = Completer<Response>();
        for (String api in apiList) {
          dio.get(api).then((res) {
            if (!completer.isCompleted) {
              completer.complete(res);
            }
          }).catchError((_) {});
        }
        return completer.future;
      }

      Response response = await getResponse(
        systemConfig.vodHostList,
        Dio(),
      );
      var res = (response.data as Map<String, dynamic>);
      return res;
    } catch (err) {
      logger.i('fetchDlJson error: $err');
    }
  }
}
