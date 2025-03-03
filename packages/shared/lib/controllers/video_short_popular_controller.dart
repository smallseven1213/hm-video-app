// getx TagPopularController, has List<Tag> obs
import 'package:get/get.dart';
import 'package:shared/controllers/auth_controller.dart';

import '../apis/area_api.dart';
import '../models/vod.dart';

class VideoShortPopularController extends GetxController {
  var data = <Vod>[].obs;
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
    AreaApi areaApi = AreaApi();
    var result = await areaApi.getPopular(areaId, videoId);
    data.value = result;
  }
}
