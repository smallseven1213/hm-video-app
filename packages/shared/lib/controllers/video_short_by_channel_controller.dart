// getx TagPopularController, has List<Tag> obs
import 'package:get/get.dart';
import 'package:shared/apis/vod_api.dart';
import 'package:shared/controllers/auth_controller.dart';

import '../models/vod.dart';

class VideoShortByChannelController extends GetxController {
  var data = <Vod>[].obs;
  int videoId = 0;
  int supplierId = 0;

  VideoShortByChannelController(this.supplierId, this.videoId);

  @override
  void onInit() async {
    super.onInit();
    fetchData(supplierId, videoId);
    Get.find<AuthController>().token.listen((event) {
      fetchData(supplierId, videoId);
    });
  }

  Future<void> fetchData(supplierId, videoId) async {
    VodApi vodApi = VodApi();
    var result =
        await vodApi.getPlayList(supplierId: supplierId, videoId: videoId);
    data.value = result;
  }
}
