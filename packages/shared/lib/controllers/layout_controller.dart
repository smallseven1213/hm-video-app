import 'package:get/get.dart';
import '../apis/channel_api.dart';
import '../models/channel.dart';

class LayoutController extends GetxController {
  final String layoutId;
  final _layout = <Channel>[].obs;
  final chnnaleApi = ChannelApi();

  LayoutController(this.layoutId);

  List<Channel> get layout => _layout.value;

  @override
  void onInit() {
    super.onInit();
    chnnaleApi.getManyByLayout(int.parse(layoutId));
  }
}
