import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../apis/live_api.dart';
import '../controllers/user_follows_controller.dart';

final liveApi = LiveApi();

class FollowLiveCheckProvider extends StatefulWidget {
  final int hid;
  final Widget Function(
    bool isFollowed,
  ) child;

  const FollowLiveCheckProvider({
    Key? key,
    required this.hid,
    required this.child,
  }) : super(key: key);

  @override
  _FollowLiveCheckProviderState createState() =>
      _FollowLiveCheckProviderState();
}

class _FollowLiveCheckProviderState extends State<FollowLiveCheckProvider> {
  bool isFollowed = false;
  final userFollowsController = Get.find<UserFollowsController>();

  @override
  void initState() {
    super.initState();
    _fetchFollowState();
  }

  void _fetchFollowState() {
    var response = userFollowsController.isFollowed(widget.hid);
    setState(() {
      isFollowed = response;
    });
  }

  void handleTap() async {
    if (isFollowed) {
      // Unfollow
      await liveApi.unfollow(widget.hid);
    } else {
      // Follow
      await liveApi.follow(widget.hid);
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
