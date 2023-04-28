import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/channel_screen_tab_controller.dart';
import 'package:shared/controllers/layout_controller.dart';

import 'channel_style_1/index.dart';

import 'channel_style_2/index.dart';
import 'channel_style_3/index.dart';
import 'channel_style_4/index.dart';
import 'channel_style_not_found/index.dart';

Map<int, Function> styleWidgetMap = {
  1: (item) => ChannelStyle1(
        key: ValueKey(item.id),
        channelId: item.id,
      ),
  2: (item) => ChannelStyle2(
        key: ValueKey(item.id),
        channelId: item.id,
      ),
  3: (item) => ChannelStyle3(
        key: ValueKey(item.id),
        channelId: item.id,
      ),
  4: (item) => ChannelStyle4(
        key: ValueKey(item.id),
        channelId: item.id,
      ),
};

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
      () {
        return PageView(
            controller: controller,
            onPageChanged: (value) =>
                channelScreenTabController.tabIndex.value = value,
            allowImplicitScrolling: false,
            physics: const CustomPageViewScrollPhysics(),
            children: layoutController.layout
                .asMap()
                .map(
                  (index, item) => MapEntry(
                    index,
                    styleWidgetMap.containsKey(item.style)
                        ? styleWidgetMap[item.style]!(item)
                        : const ChannelStyleNotFound(),
                  ),
                )
                .values
                .toList()
                .cast<Widget>());
      },
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
