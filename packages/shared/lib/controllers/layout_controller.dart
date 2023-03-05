import 'package:get/get.dart';
import '../apis/channel_api.dart';
import '../models/channel.dart';

class LayoutController extends GetxController {
  final String layoutId;
  var layout = <Channel>[].obs;
  final chnnaleApi = ChannelApi();

  LayoutController(this.layoutId);

  @override
  void onInit() async {
    super.onInit();
    var res = await chnnaleApi.getManyByLayout(int.parse(layoutId));

    layout.value = res;
  }
}
