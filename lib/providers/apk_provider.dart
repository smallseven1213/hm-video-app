import 'package:wgp_video_h5app/controllers/index.dart';
import 'package:wgp_video_h5app/models/index.dart';
import 'package:wgp_video_h5app/providers/index.dart';

class ApkProvider extends BaseProvider {
  // {{public_host}}/apkBatchPackedRecords/apkBatchPackedRecord?specificVersion=22.0714.15.1&agentCode=ABC1
  @override
  void onInit() {
    httpClient.timeout = const Duration(minutes: 1);
    httpClient.baseUrl =
        '${AppController.cc.endpoint.getApi()}/public/apkBatchPackedRecords';
    super.onInit();
  }

  // 1. 不更新、2. 建議更新、3.強制更新
  Future<ApkUpdate> checkVersion(
      {required String version, required String agentCode}) async {
    var value = await get(
        '/apkBatchPackedRecord?specificVersion=$version&agentCode=$agentCode');
    var res = (value.body as Map<String, dynamic>);
    // print(res);
    // return ApkUpdate(status: 2, url: "url");
    if (res['code'] != '00') {
      return ApkUpdate(status: 1);
    }
    int action = res['data']['isUpdateVersion'];
    String url = res['data']['download'][0]['content'];
    return ApkUpdate(status: action, url: url);
  }
}
