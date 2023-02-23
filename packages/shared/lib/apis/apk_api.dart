import 'package:shared/models/apk_update.dart';
import 'package:shared/services/system_config.dart';
import 'package:shared/utils/fetcher.dart';

final systemConfig = SystemConfig();

class ApkApi {
  // 1: 不更新、2: 建議更新、3: 強制更新
  Future<ApkUpdate> checkVersion({
    required String version,
    required String agentCode,
  }) async {
    try {
      var value = await fetcher(
          url:
              '${systemConfig.apiHost}/public/apkBatchPackedRecords/apkBatchPackedRecord?specificVersion=$version&agentCode=$agentCode');
      var res = (value.data as Map<String, dynamic>);
      if (res['code'] != '00') {
        return ApkUpdate(status: Status.noUpdate, url: '');
      }

      Status action = Status.parse(res['data']['isUpdateVersion']);
      String url = res['data']['download'][0]['content'];
      return ApkUpdate(status: action, url: url);
    } catch (err) {
      print('checkVersion error: $err');
      return ApkUpdate(status: Status.noUpdate, url: '');
    }
  }
}
