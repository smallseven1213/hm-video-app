import 'dart:async';

import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:logger/logger.dart';

import '../controllers/system_config_controller.dart';

final logger = Logger();

class DlApi {
  static final DlApi _instance = DlApi._internal();

  DlApi._internal();

  factory DlApi() {
    return _instance;
  }

  final SystemConfigController _systemConfigController =
      getx.Get.find<SystemConfigController>();

  String get apiHost => _systemConfigController.apiHost.value!;
  List<String> get dlJsonHostList =>
      _systemConfigController.dlJsonHostList.value;

  // 1: 不更新、2: 建議更新、3: 強制更新

  fetchDlJson() async {
    try {
      Future<Response> getResponse(
        List<String> apiList,
        Dio dio,
      ) async {
        var completer = Completer<Response>();

        for (String url in apiList) {
          var now = DateTime.now().millisecondsSinceEpoch;
          var newUrl = '$url?timestamp=$now';

          dio.get(newUrl).then((res) {
            if (!completer.isCompleted) {
              completer.complete(res);
            }
          }).catchError((_) {});
        }
        return completer.future;
      }

      Response response = await getResponse(
        dlJsonHostList,
        Dio(),
      );
      var res = (response.data as Map<String, dynamic>);
      return res;
    } catch (err) {
      logger.i('fetchDlJson error: $err');
    }
  }
}
