import 'package:wgp_video_h5app/controllers/index.dart';
import 'package:wgp_video_h5app/models/index.dart';
import 'package:wgp_video_h5app/providers/index.dart';

class PrivilegeProvider extends BaseProvider {
  @override
  void onInit() {
    httpClient.baseUrl =
        '${AppController.cc.endpoint.getApi()}/public/privileges';
    super.onInit();
  }

  Future<List<UserPrivilegeRecord>> getUserPrivilegeRecords({
    required String userId,
    int page = 1,
    int limit = 100,
  }) =>
      get('/privilege/list/userId?page=$page&limit=$limit&userId=$userId')
          .then((value) {
        // print('$region, $page, $sortBy, $name');
        var res = (value.body as Map<String, dynamic>);
        // var total = res['data']['total'];
        // print((res['data']['data'] as List<dynamic>).length);
        if (res['code'] != '00') {
          return [];
        }

        return List.from((res['data'] as List<dynamic>)
            .map((e) => UserPrivilegeRecord.fromJson(e)));
      });
}
