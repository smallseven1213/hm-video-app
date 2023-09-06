import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/channel_screen_tab_controller.dart';
import '../../controllers/layout_controller.dart';

class LayoutStyleTabBgColorConsumer extends StatelessWidget {
  final Widget Function({required bool needTabBgColor}) child;
  final int layoutId;

  const LayoutStyleTabBgColorConsumer(
      {Key? key, required this.child, required this.layoutId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var layoutController = Get.find<LayoutController>(tag: 'layout$layoutId');
    var channelScreenTabController =
        Get.find<ChannelScreenTabController>(tag: 'channel-screen-$layoutId');
    return Obx(() {
      var needTabBgColor = true;
      var layout = layoutController.layout;
      var tabIndex = channelScreenTabController.tabIndex.value;
      if (layout.length > tabIndex) {
        var style = layout[tabIndex].style;
        if (style == 2 || style == 6) {
          needTabBgColor = false;
        }
      }
      return child(needTabBgColor: needTabBgColor);
    });
  }
}
