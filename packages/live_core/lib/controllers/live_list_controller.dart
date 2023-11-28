import 'package:get/get.dart';

import '../apis/live_api.dart';
import '../models/live_api_response_base.dart';
import '../models/room.dart';
import '../utils/live_fetcher.dart';

final liveApi = LiveApi();

class LiveListController extends GetxController {
  var rooms = <Room>[].obs;
  // init
  @override
  void onInit() {
    super.onInit();
    _fetchData();
  }

  // fetch from "liveApi.getList"
  Future<void> _fetchData() async {
    try {
      LiveApiResponseBase<List<Room>> res = await liveApi.getRooms();
      rooms.value = res.data;
    } catch (e) {
      print(e);
    }
  }
}
