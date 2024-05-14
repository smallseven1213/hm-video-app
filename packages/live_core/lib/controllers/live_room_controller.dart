import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../models/live_room.dart';
import '../models/room.dart';
import '../socket/live_web_socket_manager.dart';
import 'live_user_controller.dart';

class LiveRoomController extends GetxController {
  int pid;
  Rx<Room?> liveRoomInfo = Rx<Room?>(null);
  var liveRoom = Rx<LiveRoom?>(null);
  Rx<double> displayAmount = 0.0.obs; // 金額
  var displayUserCount = 0.obs; // 人數
  var hasError = false.obs;
  var currentVideoPullUrl = ''.obs;
  Rx<Language?> currentTranslate = Rx<Language?>(null);
  final LiveSocketIOManager socketManager = LiveSocketIOManager();
  var hideAllUI = false.obs;
  var isMute = kIsWeb ? true.obs : false.obs;
  var displayChatInput = false.obs;

  LiveRoomController(this.pid);

  // initState
  @override
  void onInit() {
    super.onInit();
    Get.find<LiveUserController>().getUserDetail();

    // 如果currentTranslate改變了，要print('currentTranslate changed')
    ever(currentTranslate, (tran) async {
      if (tran == null) {
        currentVideoPullUrl.value = liveRoom.value?.pullUrlDecode ?? '';
      } else {
        try {
          var req = await liveApi.getStreamPullUrlByTran(tran.code);
          currentVideoPullUrl.value = req.data;
        } catch (e) {
          currentVideoPullUrl.value = liveRoom.value?.pullUrlDecode ?? '';
        }
      }
    });
  }

  // fetch from "liveApi.getList"
  Future<void> fetchData() async {
    try {
      hasError.value = false;
      var res = await liveApi.enterRoom(pid);
      liveRoom.value = res.data;
      displayAmount.value = res.data?.amount ?? 0;
      if (currentTranslate.value == null) {
        currentVideoPullUrl.value = res.data?.pullUrlDecode ?? '';
      } else {
        var req =
            await liveApi.getStreamPullUrlByTran(currentTranslate.value!.code);
        currentVideoPullUrl.value = req.data;
      }
      // currentVideoPullUrl.value = res.data?.pullUrlDecode ?? '';
    } catch (e) {
      hasError.value = true;
    }
  }

  // toggleHideAllUI
  void toggleHideAllUI() {
    hideAllUI.value = !hideAllUI.value;
  }

  // setAmount
  void setAmount(double amount) {
    displayAmount.value = amount;

    // amount第一次取代會更新沒錯，但接下來顯示用displayAmount
    // liveRoom.update((val) {
    //   val!.amount = amount;
    // });
  }

  // setCurrentTranslate
  void setCurrentTranslate(Language? language) {
    currentTranslate.value = language;
    dynamic jsonData = {
      'locale': language?.code ?? "",
    };
    socketManager.send('change-locale', jsonData);
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
      return;
    }
  }

  void toggleDisplayChatInput() {
    displayChatInput.value = !displayChatInput.value;
  }
}
