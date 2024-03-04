import 'dart:async';

import 'package:get/get.dart';

import '../apis/live_api.dart';
import '../models/live_room.dart';
import '../models/room_rank.dart';
import 'live_room_controller.dart';

final liveApi = LiveApi();

class RoomRankController extends GetxController {
  var roomRank = Rxn<RoomRank>();
  Timer? _timer;
  late LiveRoomController liveRoomController;
  String? lastPullUrl;
  int pid;
  late Worker _worker;
  var shouldShowPaymentPrompt = false.obs;
  bool userClosedDialog = false;

  RoomRankController(this.pid);

  @override
  void onInit() {
    super.onInit();
    liveRoomController = Get.find<LiveRoomController>(tag: pid.toString());

    _fetchData();

    // 设置定时器
    _startRankTimer();

    // 监听 liveRoomController 的变化
    _worker = ever(liveRoomController.liveRoom, _handleLiveRoomChange);
  }

  void _handleLiveRoomChange(LiveRoom? liveRoom) {
    if (liveRoom != null && liveRoom.pullurl != lastPullUrl) {
      lastPullUrl = liveRoom.pullurl;
      if (liveRoom.pullurl.isNotEmpty) {
        _startRankTimer();
      }
    }
  }

  void _startRankTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      _fetchData();
    });
  }

  void _fetchData() async {
    try {
      var getRoomRank = await LiveApi().getRank(pid);
      if (getRoomRank.data != null) {
        liveRoomController.setAmount(getRoomRank.data!.amount);
        liveRoomController.setUserCount(getRoomRank.data!.users);
        roomRank.value = getRoomRank.data;

        // 處理UI要不要顯示付費提示 Dialog
        if (liveRoomController.liveRoomInfo.value?.chargeType == 3 &&
            getRoomRank.data!.amount > 0) {
          if (!userClosedDialog) {
            shouldShowPaymentPrompt.value = true;
          }
        } else {
          shouldShowPaymentPrompt.value = false;
          userClosedDialog = false;
        }
      }
    } catch (e) {}
  }

  void setUserClosedDialog() {
    userClosedDialog = true;
    shouldShowPaymentPrompt.value = false;
  }

  @override
  void onClose() {
    _timer?.cancel();
    _worker.dispose();
    super.onClose();
  }
}
