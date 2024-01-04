import 'package:get/get.dart';

import '../apis/live_api.dart';
import '../models/live_room.dart';
import '../models/room.dart';
import 'commands_controller.dart';

final liveApi = LiveApi();

class LiveRoomController extends GetxController {
  int pid;
  Rx<Room?> liveRoomInfo = Rx<Room?>(null);
  var liveRoom = Rx<LiveRoom?>(null);
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

  // exit room
  Future<void> exitRoom() async {
    try {
      await liveApi.exitRoom();
      liveRoom.value = null;
    } catch (e) {
      print(e);
    }
  }
}
