import 'package:get/get.dart';
import 'package:shared/models/apk_update.dart';
import 'package:shared/utils/fetcher.dart';

import '../controllers/system_config_controller.dart';

class ApkApi {
  static final ApkApi _instance = ApkApi._internal();

  ApkApi._internal();

  factory ApkApi() {
    return _instance;
  }

  final SystemConfigController _systemConfigController =
      Get.find<SystemConfigController>();

  String get apiHost => _systemConfigController.apiHost.value!;

  // 1: 不更新、2: 建議更新、3: 強制更新
  Future<ApkUpdate> checkVersion({
    required String version,
    required String agentCode,
  }) async {
    try {
      var value = await fetcher(
          url:
              '$apiHost/public/apkBatchPackedRecords/apkBatchPackedRecord?specificVersion=$version&agentCode=$agentCode');
      var res = (value.data as Map<String, dynamic>);
      if (res['code'] != '00') {
        return ApkUpdate(status: ApkStatus.noUpdate, url: '');
      }

      ApkStatus action = ApkStatus.parse(res['data']['isUpdateVersion']);
      String url = res['data']['download'][0]['content'];
      return ApkUpdate(status: action, url: url);
    } catch (err) {
      logger.i('checkVersion error: $err');
      return ApkUpdate(status: ApkStatus.noUpdate, url: '');
    }
  }
}
