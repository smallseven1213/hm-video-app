//  is a statefull widget, has no props, return a empty Container

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/channel_screen_tab_controller.dart';
import '../controllers/layout_controller.dart';
import 'layout_tab_item_builder.dart';

class LayoutTabBuilder extends StatefulWidget {
  final int layoutId;
  final LayoutTabBarItemBuilder Function({
    required int layoutId,
    required int index,
    required String name,
  }) barItemWidget;
  final Function({
    required TabController tabController,
    required List<Widget> tabItems,
    required Function(int) onTapTabItem,
  }) tabbarWidget;

  const LayoutTabBuilder({
    Key? key,
    required this.layoutId,
    required this.tabbarWidget,
    required this.barItemWidget,
  }) : super(key: key);

  @override
  LayoutTabBuilderState createState() => LayoutTabBuilderState();
}

class LayoutTabBuilderState extends State<LayoutTabBuilder>
    with TickerProviderStateMixin {
  late TabController tabController;
  late Worker layoutWorker;
  late Worker screenTabWorker;
  late ChannelScreenTabController channelScreenTabController;
  late LayoutController layoutController;
  List<Widget> tabItems = <Widget>[];

  @override
  void initState() {
    super.initState();
    channelScreenTabController = Get.find<ChannelScreenTabController>(
        tag: 'channel-screen-${widget.layoutId}');

    layoutController =
        Get.find<LayoutController>(tag: 'layout${widget.layoutId}');
    _updateTabItems();
    _initializeTabController();

    layoutWorker = ever(layoutController.layout, (channels) {
      if (mounted) {
        setState(() {
          _updateTabItems();
          _initializeTabController();
        });
      }
    });

    screenTabWorker = ever(channelScreenTabController.tabIndex, (callback) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (tabController.index != callback && tabItems.isNotEmpty && mounted) {
          tabController.animateTo(callback);
        }
      });
    });
  }

  void handleTapTabItem(int index) {
    channelScreenTabController.pageViewIndex.value = index;
  }

  void _updateTabItems() {
    tabItems = layoutController.layout
        .map((e) => widget.barItemWidget(
              layoutId: widget.layoutId,
              index: layoutController.layout.indexOf(e),
              name: e.name,
            ))
        .toList();
  }

  void _initializeTabController() {
    tabController = TabController(
      length: tabItems.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    layoutWorker.dispose();
    screenTabWorker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.tabbarWidget(
        tabController: tabController,
        tabItems: tabItems,
        onTapTabItem: handleTapTabItem);
  }
}
