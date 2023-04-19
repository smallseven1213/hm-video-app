import 'package:app_gp/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/channel_screen_tab_controller.dart';
import 'package:shared/controllers/layout_controller.dart';
import 'package:shared/models/color_keys.dart';

import 'layout_tab_bar_item.dart';

var logger = Logger();

class LayoutTabBar extends StatefulWidget {
  final int layoutId;
  const LayoutTabBar({
    Key? key,
    required this.layoutId,
  }) : super(key: key);

  @override
  LayoutTabBarState createState() => LayoutTabBarState();
}

class LayoutTabBarState extends State<LayoutTabBar>
    with TickerProviderStateMixin {
  late ChannelScreenTabController channelScreenTabController;
  late LayoutController layoutController;

  late TabController tabController;
  List<Tab> tabItems = <Tab>[];

  @override
  void initState() {
    super.initState();
    channelScreenTabController = Get.find<ChannelScreenTabController>(
        tag: 'channel-screen-${widget.layoutId}');

    layoutController =
        Get.find<LayoutController>(tag: 'layout${widget.layoutId}');
    _updateTabItems();
    _initializeTabController();

    ever(layoutController.layout, (channels) {
      setState(() {
        _updateTabItems();
        _initializeTabController();
      });
    });

    ever(channelScreenTabController.tabIndex, (callback) {
      if (tabController.index != callback) {
        tabController.animateTo(callback);
      }
    });
  }

  void _updateTabItems() {
    tabItems = layoutController.layout
        .map((e) => Tab(
              child: Builder(
                builder: (BuildContext context) {
                  return LayoutTabBarItem(
                    layoutId: widget.layoutId,
                    index: layoutController.layout.indexOf(e),
                    name: e.name,
                  );
                },
              ),
            ))
        .toList();
  }

  void _initializeTabController() {
    tabController = TabController(
      length: tabItems.length,
      vsync: this,
    );
  }

  // @override
  // void dispose() {
  //   tabController.dispose();
  //   super.dispose();
  // }

  void handleTapTabItem(int index) {
    channelScreenTabController.pageViewIndex.value = index;
  }

  @override
  Widget build(BuildContext context) {
    if (tabItems.isEmpty) {
      return Container();
    }
    return Container(
      height: 60,
      width: double.infinity,
      color: AppColors.colors[ColorKeys.background],
      padding: const EdgeInsets.only(top: 8),
      child: TabBar(
          isScrollable: true,
          controller: tabController,
          indicatorPadding:
              const EdgeInsets.only(left: 15, right: 15, bottom: 4),
          indicatorWeight: 5,
          indicatorColor: AppColors.colors[ColorKeys.primary],
          indicator: UnderlineTabIndicator(
            borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(10), right: Radius.circular(10)),
            borderSide: BorderSide(
              width: 5.0,
              color: AppColors.colors[ColorKeys.primary]!,
            ),
          ),
          onTap: handleTapTabItem,
          tabs: tabItems),
    );
  }
}
