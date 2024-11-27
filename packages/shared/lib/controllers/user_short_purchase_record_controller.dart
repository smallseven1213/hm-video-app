import 'package:get/get.dart';
import 'package:shared/controllers/auth_controller.dart';

import '../apis/user_api.dart';
import '../models/vod.dart';

final userApi = UserApi();

class UserShortPurchaseRecordController extends GetxController {
  var data = <Vod>[].obs;

  UserShortPurchaseRecordController() {
    _fetchAndSaveCollection();
    Get.find<AuthController>().token.listen((event) {
      _fetchAndSaveCollection();
    });
  }

  Future<void> _fetchAndSaveCollection() async {
    var blockData = await userApi.getVideoPurchaseRecord(film: 2);
    data.value = blockData.vods.map((video) {
      return Vod(
        video.id,
        video.title,
        coverHorizontal: video.coverHorizontal!,
        coverVertical: video.coverVertical!,
        timeLength: video.timeLength!,
        tags: video.tags!,
        videoViewTimes: video.videoViewTimes!,
        aspectRatio: video.aspectRatio!,
        // detail: video.detail,
      );
    }).toList();
  }
}
