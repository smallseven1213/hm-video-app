import 'package:wgp_video_h5app/controllers/index.dart';
import 'package:wgp_video_h5app/models/index.dart';
import 'package:wgp_video_h5app/providers/index.dart';

import '../models/video.dart';

class BlockProvider extends BaseProvider {
  @override
  void onInit() {
    httpClient.baseUrl = '${AppController.cc.endpoint.getApi()}/public/areas';
    super.onInit();
  }

  Future<List<Block>> getManyByChannel(int channelId) =>
      get('/area?channelId=$channelId&page=1&limit=100').then((value) {
        // print(value.body);
        var res = (value.body as Map<String, dynamic>);
        if (res['code'] != '00') {
          return [];
        }
        return List.from((res['data']['data'] as List<dynamic>)
            .map((e) => Block.fromJson(e)));
      });

  Future<List<Video>> getShortVideoPopular(int blockId, int videoId) =>
      get('/area/shortVideo/popular?areaId=$blockId&videoId=$videoId').then((value) {
        var res = (value.body as Map<String, dynamic>);
        if (res['code'] != '00') {
          return [];
        }

        return List.from((res['data'][0]['videos']   as List<dynamic>)
            .map((e) => Video.fromJson(e)));
      });
}
