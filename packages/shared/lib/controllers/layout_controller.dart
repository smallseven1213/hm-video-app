import 'package:get/get.dart';
import 'package:shared/controllers/auth_controller.dart';
import '../apis/channel_api.dart';
import '../models/slim_channel.dart';
import 'channel_data_controller.dart';

class LayoutController extends GetxController {
  final int layoutId;
  var layout = <SlimChannel>[].obs;
  final chnnaleApi = ChannelApi();

  LayoutController(this.layoutId);

  @override
  void onInit() async {
    super.onInit();
    fetchData();
    Get.find<AuthController>().token.listen((event) {
      fetchData();
    });
    update();
  }

  Future<void> fetchData() async {
    var res = await chnnaleApi.getManyByLayout(layoutId);

    for (var item in res) {
      Get.lazyPut<ChannelDataController>(
          () => ChannelDataController(channelId: item.id),
          tag: 'channelId-${item.id}');
    }

    layout.value = res;
  }
}
