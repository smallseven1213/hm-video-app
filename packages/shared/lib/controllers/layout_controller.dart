import 'package:get/get.dart';
import '../apis/channel_api.dart';
import '../models/channel.dart';
import 'channel_data_controller.dart';

class LayoutController extends GetxController {
  final String layoutId;
  var layout = <Channel>[].obs;
  final chnnaleApi = ChannelApi();

  LayoutController(this.layoutId);

  @override
  void onInit() async {
    super.onInit();
    var res = await chnnaleApi.getManyByLayout(int.parse(layoutId));

    for (var item in res) {
      Get.lazyPut<ChannelDataController>(
          () => ChannelDataController(channelId: item.id),
          tag: 'channelId-${item.id}');
    }

    layout.value = res;
    update();
  }
}
