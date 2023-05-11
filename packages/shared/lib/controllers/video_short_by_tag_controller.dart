// getx TagPopularController, has List<Tag> obs
import 'package:get/get.dart';
import 'package:shared/controllers/auth_controller.dart';

import '../apis/tag_api.dart';
import '../models/video.dart';

class VideoShortByTagController extends GetxController {
  var data = <Video>[].obs;
  int tagId = 0;
  int videoId = 0;

  VideoShortByTagController(this.tagId, this.videoId);

  @override
  void onInit() async {
    super.onInit();
    fetchData(tagId, videoId);
    Get.find<AuthController>().token.listen((event) {
      fetchData(tagId, videoId);
    });
  }

  Future<void> fetchData(tagId, videoId) async {
    TagApi tagApi = TagApi();
    var result = await tagApi.getPlayList(tagId: tagId, videoId: videoId);
    data.value = result;
  }
}
