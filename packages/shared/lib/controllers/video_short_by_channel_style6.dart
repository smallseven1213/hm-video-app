// getx TagPopularController, has List<Tag> obs
import 'package:game/models/hm_api_response_pagination.dart';
import 'package:get/get.dart';
import 'package:shared/apis/vod_api.dart';
import 'package:shared/controllers/auth_controller.dart';

import '../models/vod.dart';

class VideoShortByChannelStyle6Controller extends GetxController {
  var data = <Vod>[].obs;
  var isInit = false.obs;
  int _page = 1;

  VideoShortByChannelStyle6Controller();

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
    HMApiResponsePaginationData<List<Vod>> result =
        await vodApi.getFollows(page: _page);

    int totalPage = (result.total! / int.parse(result.limit!)).ceil();

    if (result.total! - (_page * int.parse(result.limit!)) <
            int.parse(result.limit!) ||
        _page + 1 > totalPage) {
      _page = 1;
    } else {
      _page++;
    }

    if (isInit.value == false) {
      isInit.value = true;
    }

    data.value = result.data!;
  }
}
