import 'package:get/get.dart';

import '../apis/live_api.dart';
import '../models/live_room.dart';
import '../models/room.dart';
import 'live_user_controller.dart';

final liveApi = LiveApi();

class LiveRoomController extends GetxController {
  int pid;
  Rx<Room?> liveRoomInfo = Rx<Room?>(null);
  var liveRoom = Rx<LiveRoom?>(null);
  Rx<double> displayAmount = 0.0.obs; // 金額
  var displayUserCount = 0.obs; // 人數
  var hasError = false.obs;
  LiveRoomController(this.pid);

  // initState
  @override
  void onInit() {
    super.onInit();
    Get.find<LiveUserController>().getUserDetail();
  }

  // fetch from "liveApi.getList"
  Future<void> fetchData() async {
    try {
      hasError.value = false;
      var res = await liveApi.enterRoom(pid);
      print(res);
      liveRoom.value = res.data;
      displayAmount.value = res.data?.amount ?? 0;
    } catch (e) {
      hasError.value = true;
    }
  }

  // setAmount
  void setAmount(double amount) {
    displayAmount.value = amount;

    // amount第一次取代會更新沒錯，但接下來顯示用displayAmount
    // liveRoom.update((val) {
    //   val!.amount = amount;
    // });
  }

  // setUserCount
  void setUserCount(int userCount) {
    displayUserCount.value = userCount;
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
