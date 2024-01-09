import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:live_core/controllers/live_room_controller.dart';
import 'package:live_core/models/room_rank.dart';

import '../apis/live_api.dart';
import '../models/live_room.dart';

class RankProvider extends StatefulWidget {
  final int pid;
  final Widget Function(RoomRank? roomRank) child;

  const RankProvider({Key? key, required this.pid, required this.child})
      : super(key: key);

  @override
  _RankProviderState createState() => _RankProviderState();
}

class _RankProviderState extends State<RankProvider> {
  RoomRank? roomRank;
  late Timer _timer;
  late LiveRoomController liveRoomController;

  // listRoomControllerLisnter
  late StreamSubscription<LiveRoom?> listRoomControllerLisnter;

  @override
  void initState() {
    super.initState();
    liveRoomController =
        Get.find<LiveRoomController>(tag: widget.pid.toString());

    if (liveRoomController.liveRoom.value?.pullurl != null &&
        liveRoomController.liveRoom.value?.pullurl != "") {
      _startRankTimer();
    }

    String? lastPullUrl;

    // 監聽liveRoomController.liveRoom.value?.pullUrl的值，如果為不為null也不為""，則開始計時"
    listRoomControllerLisnter = liveRoomController.liveRoom.listen((liveRoom) {
      if (liveRoom != null && liveRoom.pullurl != lastPullUrl) {
        lastPullUrl = liveRoom.pullurl; // 更新儲存的pullurl
        if (liveRoom.pullurl.isNotEmpty) {
          _startRankTimer(); // 只有在pullurl變化時才呼叫這個方法
        }
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    listRoomControllerLisnter.cancel();
    super.dispose();
  }

  void _startRankTimer() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      try {
        var getRoomRank = await LiveApi().getRank();

        // liveRoomController.liveRoom.value?.amount = getRoomRank.data.amount;
        liveRoomController.liveRoom.update((val) {
          val!.amount = getRoomRank.data.amount;
        });

        setState(() {
          roomRank = getRoomRank.data;
        });
      } catch (e) {
        print(e);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child(roomRank);
  }
}
