// getx TagPopularController, has List<Tag> obs
import 'package:get/get.dart';
import 'package:shared/controllers/auth_controller.dart';

import '../apis/vod_api.dart';
import '../models/video.dart';

class VideoShortPopularController extends GetxController {
  var data = <Video>[].obs;
  int areaId = 0;
  int videoId = 0;

  VideoShortPopularController(this.areaId, this.videoId);

  @override
  void onInit() async {
    super.onInit();
    fetchPopular(areaId, videoId);
    Get.find<AuthController>().token.listen((event) {
      fetchPopular(areaId, videoId);
    });
  }

  Future<void> fetchPopular(areaId, videoId) async {
    VodApi vodApi = VodApi();
    var result = await vodApi.getPopular(areaId, videoId);
    data.value = result;
  }
}
