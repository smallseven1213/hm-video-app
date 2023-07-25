import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/channel_screen_tab_controller.dart';
import '../controllers/layout_controller.dart';
import '../physics/channel_page_scroll_physics.dart';

class ChannelsBuilder extends StatefulWidget {
  final int layoutId;
  final Map<int, Function> styleWidgetMap;
  final Widget? notFoundWidget;

  ChannelsBuilder({
    Key? key,
    required this.layoutId,
    required this.styleWidgetMap,
    this.notFoundWidget,
  }) : super(key: key) {
    assert(styleWidgetMap.length == 5,
        'styleWidgetMap must contain exactly 5 items.');
    assert(styleWidgetMap.keys.toSet().containsAll([1, 2, 3, 4, 5]),
        'styleWidgetMap keys must include 1, 2, 3, 4, 5');
  }

  @override
  ChannelsBuilderState createState() => ChannelsBuilderState();
}

class ChannelsBuilderState extends State<ChannelsBuilder> {
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
            physics: kIsWeb ? null : const ChannelPageScrollPhysics(),
            children: layoutController.layout
                .asMap()
                .map(
                  (index, item) => MapEntry(
                      index,
                      widget.styleWidgetMap.containsKey(item.style)
                          ? widget.styleWidgetMap[item.style]!(item)
                          : widget.notFoundWidget ??
                              const Center(
                                child: Text('Not found'),
                              )),
                )
                .values
                .toList()
                .cast<Widget>());
      },
    );
  }
}
