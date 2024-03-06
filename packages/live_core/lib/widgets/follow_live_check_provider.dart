import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../apis/live_api.dart';
import '../controllers/live_room_controller.dart';
import '../controllers/user_follows_controller.dart';
import '../models/streamer.dart';

final liveApi = LiveApi();

class FollowLiveCheckProvider extends StatefulWidget {
  final int hid;
  final int pid;
  final String streamerNickname;
  final Widget Function(
    bool isFollowed,
  ) child;

  const FollowLiveCheckProvider({
    Key? key,
    required this.pid,
    required this.hid,
    required this.streamerNickname,
    required this.child,
  }) : super(key: key);

  @override
  FollowLiveCheckProviderState createState() => FollowLiveCheckProviderState();
}

class FollowLiveCheckProviderState extends State<FollowLiveCheckProvider> {
  final userFollowsController = Get.find<UserFollowsController>();
  late LiveRoomController liveRoomController;

  bool isFollowed = false;

  @override
  void initState() {
    super.initState();
    liveRoomController =
        Get.find<LiveRoomController>(tag: widget.pid.toString());
    isFollowed = liveRoomController.liveRoom.value?.follow ?? false; // 初始值設置
  }

  void handleTap() async {
    var currentFollowStatus =
        liveRoomController.liveRoom.value?.follow ?? false;
    if (currentFollowStatus) {
      // Unfollow
      userFollowsController.unfollow(widget.hid);
    } else {
      // Follow
      userFollowsController.follow(Streamer(
        id: widget.hid,
        nickname: widget.streamerNickname,
        account: '',
      ));
    }

    var nextFollow = !currentFollowStatus;
    liveRoomController.liveRoom.value?.follow = nextFollow;
    setState(() {
      isFollowed = nextFollow; // 使用 setState 更新 isFollowed
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: handleTap,
      child: widget.child(isFollowed),
    );
  }
}
