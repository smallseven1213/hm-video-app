import 'package:wgp_video_h5app/controllers/index.dart';
import 'package:wgp_video_h5app/models/index.dart';
import 'package:wgp_video_h5app/providers/index.dart';

class JingangProvider extends BaseProvider {
  @override
  void onInit() {
    httpClient.baseUrl =
        '${AppController.cc.endpoint.getApi()}/public/jingangs';
    super.onInit();
  }

  Future<List<JinGang>> getMany(List<int> jingang) =>
      get('/jingang/list?id=${jingang.join(',')}').then((value) {
        // print(value.body);
        var res = (value.body as Map<String, dynamic>);
        if (res['code'] != '00') {
          return [];
        }
        return List.from(
            (res['data'] as List<dynamic>).map((e) => JinGang.fromJson(e)));
      });
}
