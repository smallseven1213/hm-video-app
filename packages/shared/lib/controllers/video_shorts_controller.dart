import 'package:get/get.dart';
import 'package:shared/controllers/auth_controller.dart';

import '../apis/vod_api.dart';
import '../enums/shorts_type.dart';
import '../models/vod.dart';

class VideoShortsController extends GetxController {
  var data = <Vod>[].obs;
  ShortsType type;
  int id = 0;
  int videoId = 0;

  VideoShortsController(this.type, this.id, this.videoId);

  @override
  void onInit() async {
    super.onInit();
    fetchData(type, id, videoId);
    Get.find<AuthController>().token.listen((event) {
      fetchData(type, id, videoId);
    });
  }

  Future<void> fetchData(ShortsType type, int id, int videoId) async {
    VodApi vodApi = VodApi();
    var result = await vodApi.getPlayList(type: type, id: id, videoId: videoId);
    data.value = result;
  }
}
