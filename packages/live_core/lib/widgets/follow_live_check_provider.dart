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
  _FollowLiveCheckProviderState createState() =>
      _FollowLiveCheckProviderState();
}

class _FollowLiveCheckProviderState extends State<FollowLiveCheckProvider> {
  final userFollowsController = Get.find<UserFollowsController>();
  late LiveRoomController liveRoomController;

  bool isFollowed = false;

  @override
  void initState() {
    super.initState();

    liveRoomController =
        Get.find<LiveRoomController>(tag: widget.pid.toString());

    setState(() {
      isFollowed = liveRoomController.liveRoom.value?.follow ?? false;
    });
  }

  void handleTap() async {
    var isFollowed = liveRoomController.liveRoom.value?.follow ?? false;
    if (isFollowed) {
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

    setState(() {
      isFollowed = !isFollowed;
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
