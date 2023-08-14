import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/models/slim_channel.dart';

import '../../controllers/channel_screen_tab_controller.dart';
import '../../controllers/layout_controller.dart';
import '../../physics/channel_page_scroll_physics.dart';

class ChannelsScaffold extends StatefulWidget {
  final int layoutId;
  final Widget? notFoundWidget;
  final Widget Function(SlimChannel channelData) child;

  const ChannelsScaffold({
    Key? key,
    required this.layoutId,
    required this.child,
    this.notFoundWidget,
  }) : super(key: key);

  @override
  ChannelsScaffoldState createState() => ChannelsScaffoldState();
}

class ChannelsScaffoldState extends State<ChannelsScaffold> {
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      everWorker = ever(channelScreenTabController.pageViewIndex, (int page) {
        if (controller.hasClients) {
          controller.jumpToPage(page);
        }
      });
      for (var i = 0; i < layoutController.layout.length; i++) {
        if (layoutController.layout[i].isDefault == 1) {
          channelScreenTabController.pageViewIndex.value = i;
          controller.jumpToPage(i);
          break;
        }
      }
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
            physics: kIsWeb ? null : const ChannelPageScrollPhysics(),
            children: layoutController.layout
                .asMap()
                .map((index, channelData) =>
                    MapEntry(index, widget.child(channelData)))
                .values
                .toList()
                .cast<Widget>());
      },
    );
  }
}
