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
  const LayoutTabBar({
    Key? key,
  }) : super(key: key);

  @override
  LayoutTabBarState createState() => LayoutTabBarState();
}

class LayoutTabBarState extends State<LayoutTabBar>
    with TickerProviderStateMixin {
  final ChannelScreenTabController channelScreenTabController =
      Get.find<ChannelScreenTabController>();
  final LayoutController layoutController =
      Get.find<LayoutController>(tag: 'layout1');
  late TabController tabController;
  List<Tab> tabItems = <Tab>[];

  @override
  void initState() {
    super.initState();

    ever(layoutController.layout, (channels) {
      setState(() {
        tabItems = channels
            .map((e) => Tab(child: Builder(
                  builder: (BuildContext context) {
                    return LayoutTabBarItem(
                      index: channels.indexOf(e),
                      name: e.name,
                    );
                  },
                )))
            .toList();
      });
    });

    ever(
        channelScreenTabController.tabIndex,
        (callback) => {
              if (tabController.index != callback)
                {
                  tabController.animateTo(callback),
                }
            });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  void handleTapTabItem(int index) {
    channelScreenTabController.pageViewIndex.value = index;
  }

  @override
  Widget build(BuildContext context) {
    tabController = TabController(
      length: tabItems.length,
      vsync: this,
    );
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
