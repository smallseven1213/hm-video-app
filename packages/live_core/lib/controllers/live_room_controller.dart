import 'package:get/get.dart';

import '../apis/live_api.dart';
import '../models/live_room.dart';
import '../models/room.dart';
import 'commands_controller.dart';

final liveApi = LiveApi();

class LiveRoomController extends GetxController {
  int pid;
  Rx<Room?> liveRoomInfo = Rx<Room?>(null);
  var liveRoom = LiveRoom(
          chattoken: '', pid: 0, pullurl: '', pullUrlDecode: null, amount: 0)
      .obs;
  var hasError = false.obs;
  LiveRoomController(this.pid);

  // fetch from "liveApi.getList"
  Future<void> fetchData() async {
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
