import 'package:wgp_video_h5app/controllers/index.dart';
import 'package:wgp_video_h5app/models/index.dart';
import 'package:wgp_video_h5app/providers/index.dart';

class NoticeProvider extends BaseProvider {
  @override
  void onInit() {
    httpClient.baseUrl = '${AppController.cc.endpoint.getApi()}/public/notices';
    super.onInit();
  }

  Future<List<Notice>> getMany({int page = 1, int limit = 100}) =>
      get('/notice/announcement?page=$page&limit=$limit').then((value) {
        var res = (value.body as Map<String, dynamic>);
        if (res['code'] != '00') {
          return [];
        }
        if (res['data']['data'] != null) {
          return List.from(res['data']['data'] as List<dynamic>)
              .map((e) => Notice.fromJson(e))
              .toList();
        }
        return [];
      });

  Future<Notice?> getBounceOne() => get('/notice/latest/bounce').then((value) {
        var res = (value.body as Map<String, dynamic>);
        if (res['code'] != '00') {
          return null;
        }
        if (res['data'] != null) {
          return Notice.fromJson(res['data']);
        }
        return null;
      });

  Future<List<Notice>?> getMarquee() =>
      get('/notice/latest/marquee').then((value) {
        var res = (value.body as Map<String, dynamic>);
        // print(res);
        if (res['code'] != '00') {
          return null;
        }
        if (res['data'] != null) {
          return List.from(
              (res['data'] as List<dynamic>).map((e) => Notice.fromJson(e)));
        }
        return null;
      });
}
