import 'package:get/get.dart';
import 'package:shared/controllers/auth_controller.dart';

import '../apis/user_api.dart';
import '../models/vod.dart';

final userApi = UserApi();

class UserVodPurchaseRecordController extends GetxController {
  var videos = <Vod>[].obs;

  @override
  void onInit() {
    super.onInit();
    _init();
    Get.find<AuthController>().token.listen((event) {
      _init();
    });
  }

  Future<void> _init() async {
    await _fetchAndSaveCollection();
  }

  Future<void> _fetchAndSaveCollection() async {
    var blockData = await userApi.getVideoPurchaseRecord();
    videos.value = blockData.vods
        .map((video) => Vod(
              video.id,
              video.title,
              coverHorizontal: video.coverHorizontal!,
              coverVertical: video.coverVertical!,
              timeLength: video.timeLength!,
              tags: video.tags!,
              videoViewTimes: video.videoViewTimes!,
              // detail: video.detail,
            ))
        .toList();
  }
}
