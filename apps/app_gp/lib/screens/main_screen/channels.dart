import 'package:app_gp/screens/main_screen/channel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/channel_screen_tab_controller.dart';
import 'package:shared/controllers/layout_controller.dart';

class Channels extends StatefulWidget {
  const Channels({Key? key}) : super(key: key);

  @override
  _ChannelsState createState() => _ChannelsState();
}

class _ChannelsState extends State<Channels> {
  final PageController controller = PageController();
  final layoutController = Get.find<LayoutController>(tag: 'layout1');

  final ChannelScreenTabController channelScreenTabController =
      Get.put(ChannelScreenTabController(), permanent: true);

  @override
  void initState() {
    controller.addListener(() {
      channelScreenTabController.pageViewIndex.value = controller.page!.toInt();
    });

    ever(channelScreenTabController.pageViewIndex, (int page) {
      controller.jumpToPage(page);
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    channelScreenTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PageView(
        controller: controller,
        allowImplicitScrolling: true,
        children: layoutController.layout
            .asMap()
            .map(
              (index, item) => MapEntry(
                index,
                MainChannelScreen(
                  channelId: item.id.toString(),
                ),
              ),
            )
            .values
            .toList(),
      ),
    );
  }
}
