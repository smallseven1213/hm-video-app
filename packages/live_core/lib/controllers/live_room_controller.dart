import 'package:get/get.dart';

import '../apis/live_api.dart';
import '../models/live_room.dart';
import '../models/room.dart';

final liveApi = LiveApi();

class LiveRoomController extends GetxController {
  Rx<Room?> liveRoomInfo = Rx<Room?>(null);
  var liveRoom = LiveRoom(
    chattoken: '',
    pid: 0,
    pullurl: '',
    pullUrlDecode: null,
  ).obs;
  var hasError = false.obs;
  LiveRoomController(int pid) {
    _fetchData(pid);
  }

  // fetch from "liveApi.getList"
  Future<void> _fetchData(int pid) async {
    try {
      hasError.value = false;
      var res = await liveApi.enterRoom(pid);
      liveRoom.value = res.data;
    } catch (e) {
      print(e);
      hasError.value = true;
    }
  }
}
