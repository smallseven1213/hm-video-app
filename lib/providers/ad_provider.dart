import 'package:wgp_video_h5app/controllers/index.dart';
import 'package:wgp_video_h5app/models/index.dart';
import 'package:wgp_video_h5app/providers/index.dart';

class AdProvider extends BaseProvider {
  @override
  void onInit() {
    httpClient.baseUrl = '${AppController.cc.endpoint.getApi()}/public';
    super.onInit();
  }

  Future<ChannelBanner> getBannersByChannel(int channelId) =>
      get('/banners/banner/channel?channelId=$channelId').then((value) {
        var res = (value.body as Map<String, dynamic>);
        if (res['code'] != '00') {
          return ChannelBanner([], {});
        }
        return ChannelBanner.fromJson(res['data']);
      });

  Future<List<BannerPhoto>> getBannersByPosition(int positionId) =>
      get('/banners/banner/position?positionId=$positionId').then((value) {
        var res = (value.body as Map<String, dynamic>);
        if (res['code'] != '00') {
          return [];
        }
        return List.from(res['data'] as List<dynamic>)
            .map((e) => BannerPhoto.fromJson(e))
            .toList();
      });

  Future<void> clickedBanner(int bannerId) async {
    if (bannerId == 0)
      return;

    await post('/banners/banner/bannerClickRecord', {
      'bannerId': bannerId,
    });
  }
}
