import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/channel_screen_tab_controller.dart';
import 'package:shared/controllers/layout_controller.dart';

import 'channel/index.dart';

class Channels extends StatefulWidget {
  const Channels({Key? key}) : super(key: key);

  @override
  _ChannelsState createState() => _ChannelsState();
}

class _ChannelsState extends State<Channels> {
  int activePageIndex = 0;
  final PageController controller = PageController();
  final layoutController = Get.find<LayoutController>(tag: 'layout1');

  final ChannelScreenTabController channelScreenTabController =
      Get.put(ChannelScreenTabController(), permanent: true);

  @override
  void initState() {
    ever(channelScreenTabController.pageViewIndex, (int page) {
      controller.jumpToPage(page);
    });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PageView(
        controller: controller,
        onPageChanged: (value) =>
            channelScreenTabController.tabIndex.value = value,
        allowImplicitScrolling: true,
        children: layoutController.layout
            .asMap()
            .map(
              (index, item) => MapEntry(
                index,
                Channel(
                  channelId: item.id,
                ),
              ),
            )
            .values
            .toList(),
      ),
    );
  }
}
