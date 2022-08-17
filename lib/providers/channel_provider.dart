import 'package:wgp_video_h5app/controllers/index.dart';
import 'package:wgp_video_h5app/models/index.dart';
import 'package:wgp_video_h5app/providers/index.dart';

class ChannelProvider extends BaseProvider {
  @override
  void onInit() {
    httpClient.baseUrl =
        '${AppController.cc.endpoint.getApi()}/public/channels';
    super.onInit();
  }

  Future<List<Channel>> getManyByLayout(int layoutId) =>
      get('/channel/list?layout=$layoutId').then((value) {
        var res = (value.body as Map<String, dynamic>);
        if (res['code'] != '00') {
          return [];
        }
        return List.from(
            (res['data'] as List<dynamic>).map((e) => Channel.fromJson(e)));
      });
}
