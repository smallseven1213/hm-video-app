// DisplayLayoutTabSearch, 會帶入一個child widget, 會參考2個GetX Controller
// 第1個是LayoutController，取layout.obs的值
// 第2個是channelScreenTabController.tabIndex.value
// 當layout[channelScreenTabController.tabIndex.value]的isSearch為true時, display child widget

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/widgets/fade_in_effect.dart';

import '../controllers/channel_screen_tab_controller.dart';
import '../controllers/layout_controller.dart';

class DisplayLayoutTabSearch extends StatelessWidget {
  final Widget Function({required bool displaySearchBar}) child;
  final int layoutId;

  const DisplayLayoutTabSearch(
      {Key? key, required this.child, required this.layoutId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var layoutController = Get.find<LayoutController>(tag: 'layout$layoutId');
    var channelScreenTabController =
        Get.find<ChannelScreenTabController>(tag: 'channel-screen-$layoutId');
    return Obx(() {
      var displaySearchBar = false;
      var layout = layoutController.layout;
      var tabIndex = channelScreenTabController.tabIndex.value;
      if (layout.length > tabIndex) {
        var isSearch = layout[tabIndex].isSearch;
        if (isSearch) {
          displaySearchBar = true;
        }
      }
      return child(displaySearchBar: displaySearchBar);
    });
  }
}
