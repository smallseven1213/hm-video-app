// getx TagPopularController, has List<Tag> obs
import 'package:get/get.dart';
import 'package:shared/controllers/auth_controller.dart';

import '../apis/tag_api.dart';
import '../models/tag.dart';

class TagPopularController extends GetxController {
  var data = <Tag>[].obs;

  @override
  void onInit() async {
    super.onInit();
    fetchPopular();
    Get.find<AuthController>().token.listen((event) {
      fetchPopular();
    });
  }

  Future<void> fetchPopular() async {
    TagApi tagApi = TagApi();
    var result = await tagApi.getPopular();
    data.value = result;
  }
}
