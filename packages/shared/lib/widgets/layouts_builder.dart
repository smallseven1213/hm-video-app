import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/bottom_navigator_controller.dart';
import '../controllers/channel_screen_tab_controller.dart';
import '../controllers/layout_controller.dart';
import '../models/navigation.dart';

class LayoutsBuilder extends StatefulWidget {
  final List<int> layoutIds;
  final String? defaultScreenKey;
  final Map<String, Widget Function()> screens;
  final Widget? screenNotFoundWidget;
  final Function? doOnInitState;
  final Function(
      {required String activeKey,
      required List<Navigation> navigatorItems,
      required Function(String tabKey) changeTabKey}) bottomNavigationBarWidget;

  const LayoutsBuilder(
      {Key? key,
      required this.layoutIds,
      required this.screens,
      this.defaultScreenKey,
      this.screenNotFoundWidget,
      this.doOnInitState,
      required this.bottomNavigationBarWidget})
      : super(key: key);

  @override
  LayoutsBuilderState createState() => LayoutsBuilderState();
}

class LayoutsBuilderState extends State<LayoutsBuilder> {
  final bottomNavigatorController = Get.find<BottonNavigatorController>();

  // init
  @override
  void initState() {
    if (widget.defaultScreenKey != null) {
      bottomNavigatorController.changeKey(widget.defaultScreenKey!);
    }
    for (var layout in widget.layoutIds) {
      Get.put(ChannelScreenTabController(),
          tag: 'channel-screen-$layout', permanent: false);
      Get.put(LayoutController(layout), tag: 'layout$layout', permanent: false);
    }

    if (widget.doOnInitState != null) {
      widget.doOnInitState!();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var activeKey = bottomNavigatorController.activeKey.value;
      if (!widget.screens.containsKey(activeKey)) {
        if (widget.screenNotFoundWidget != null) {
          return widget.screenNotFoundWidget!;
        }
        return const SizedBox.shrink();
      }

      final currentScreen = widget.screens[activeKey]!();

      return Scaffold(
        body: currentScreen,
        bottomNavigationBar: bottomNavigatorController.navigatorItems.isEmpty
            ? null
            : widget.bottomNavigationBarWidget(
                activeKey: activeKey,
                navigatorItems: bottomNavigatorController.navigatorItems,
                changeTabKey: (String tabKey) {
                  bottomNavigatorController.changeKey(tabKey);
                }),
      );
    });
  }
}
