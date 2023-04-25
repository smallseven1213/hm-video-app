import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/channel_screen_tab_controller.dart';
import 'package:shared/controllers/layout_controller.dart';

import 'channel/index.dart';
import 'package:flutter/physics.dart';

class CustomPageScrollPhysics extends BouncingScrollPhysics {
  CustomPageScrollPhysics({required ScrollPhysics parent})
      : super(parent: parent);

  @override
  SpringDescription get spring => SpringDescription(
        mass: 0.5,
        stiffness: 400,
        damping: 0.5,
      );
}

class Channels extends StatefulWidget {
  final int layoutId;
  const Channels({Key? key, required this.layoutId}) : super(key: key);

  @override
  _ChannelsState createState() => _ChannelsState();
}

class _ChannelsState extends State<Channels> {
  int activePageIndex = 0;
  final PageController controller = PageController();

  late ChannelScreenTabController channelScreenTabController;
  late LayoutController layoutController;
  late final Worker everWorker;

  @override
  void initState() {
    channelScreenTabController = Get.find<ChannelScreenTabController>(
        tag: 'channel-screen-${widget.layoutId}');
    layoutController =
        Get.find<LayoutController>(tag: 'layout${widget.layoutId}');
    everWorker = ever(channelScreenTabController.pageViewIndex, (int page) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (controller.hasClients) {
          controller.jumpToPage(page);
        }
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    everWorker.dispose();
    channelScreenTabController.reset();

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
        physics: const CustomPageViewScrollPhysics(),
        children: layoutController.layout
            .asMap()
            .map(
              (index, item) => MapEntry(
                index,
                Channel(
                  key: ValueKey(item.id),
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

class CustomPageViewScrollPhysics extends ScrollPhysics {
  const CustomPageViewScrollPhysics({ScrollPhysics? parent})
      : super(parent: parent);

  @override
  CustomPageViewScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomPageViewScrollPhysics(parent: buildParent(ancestor)!);
  }

  @override
  SpringDescription get spring => const SpringDescription(
        mass: 50,
        stiffness: 100,
        damping: 1,
      );
}
