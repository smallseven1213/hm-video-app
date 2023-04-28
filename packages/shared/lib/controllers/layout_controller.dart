import 'package:get/get.dart';
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
    var res = await chnnaleApi.getManyByLayout(layoutId);

    for (var item in res) {
      Get.lazyPut<ChannelDataController>(
          () => ChannelDataController(channelId: item.id),
          tag: 'channelId-${item.id}');
    }

    layout.value = res;
    update();
  }
}
