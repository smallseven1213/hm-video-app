import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/bottom_navigator_controller.dart';
import '../controllers/channel_screen_tab_controller.dart';
import '../controllers/layout_controller.dart';

class ChannelLayoutBuilder extends StatefulWidget {
  final int layoutId;
  final Widget child;

  const ChannelLayoutBuilder(
      {Key? key, required this.layoutId, required this.child})
      : super(key: key);

  @override
  ChannelLayoutBuilderState createState() => ChannelLayoutBuilderState();
}

class ChannelLayoutBuilderState extends State<ChannelLayoutBuilder> {
  // init
  @override
  void initState() {
    Get.put(ChannelScreenTabController(),
        tag: 'channel-screen-${widget.layoutId}', permanent: false);
    Get.put(LayoutController(widget.layoutId),
        tag: 'layout${widget.layoutId}', permanent: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
