// getx TagPopularController, has List<Tag> obs
import 'package:get/get.dart';
import 'package:shared/apis/vod_api.dart';
import 'package:shared/controllers/auth_controller.dart';

import '../models/vod.dart';

class VideoShortByChannelStyle2Controller extends GetxController {
  var data = <Vod>[].obs;

  VideoShortByChannelStyle2Controller();

  @override
  void onInit() async {
    super.onInit();
    fetchData();
    Get.find<AuthController>().token.listen((event) {
      fetchData();
    });
  }

  Future<void> fetchData() async {
    VodApi vodApi = VodApi();
    var result = await vodApi.getRecommends();
    data.value = result;
  }
}
