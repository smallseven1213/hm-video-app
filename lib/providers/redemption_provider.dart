import 'package:wgp_video_h5app/controllers/index.dart';
import 'package:wgp_video_h5app/models/index.dart';
import 'package:wgp_video_h5app/models/videos_tag.dart';
import 'package:wgp_video_h5app/providers/index.dart';

import '../models/redemption.dart';

class RedemptionProvider extends BaseProvider {
  @override
  void onInit() {
    httpClient.baseUrl = '${AppController.cc.endpoint.getApi()}/public/redemption';
    super.onInit();
  }

  Future<List<Redemption>> records() =>
      get('/redemption/records')
          .then((value) {
        // print('$region, $page, $sortBy, $name');
        var res = (value.body as Map<String, dynamic>);
        // var total = res['data']['total'];
        // print((res['data']['data'] as List<dynamic>).length);
        if (res['code'] != '00') {
          return [];
        }
        return List.from((res['data'] as List<dynamic>)
            .map((e) => Redemption.fromJson(e)));
      });


  Future<String> redeem(String serialNumberId)  async {
    var value = await post('/redemption/redeem', {
      'serialNumberId': serialNumberId,
    });

    var res = (value.body as Map<String, dynamic>);
    if (res['code'] != '00') {
      return res['message'];
    }
    return "兌換成功";

  }
}
