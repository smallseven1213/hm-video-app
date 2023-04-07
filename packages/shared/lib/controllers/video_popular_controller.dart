// getx VideoPopularController, 會有一個List<Vod>的obs
import 'package:get/get.dart';

import '../apis/vod_api.dart';
import '../models/vod.dart';

final vodApi = VodApi();

class VideoPopularController extends GetxController {
  var data = <Vod>[].obs;

  @override
  void onInit() async {
    super.onInit();
    fetchPopular();
  }

  Future<void> fetchPopular() async {
    var result = await vodApi.getVideoByTags();
    data.value = result.vods;
  }
}
