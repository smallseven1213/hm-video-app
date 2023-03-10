import 'package:app_gp/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/channel_screen_tab_controller.dart';
import 'package:shared/controllers/layout_controller.dart';
import 'package:shared/models/color_keys.dart';

var logger = Logger();

class Tabbar extends StatefulWidget {
  const Tabbar({
    Key? key,
  }) : super(key: key);

  @override
  _TabbarState createState() => _TabbarState();
}

class _TabbarState extends State<Tabbar> with TickerProviderStateMixin {
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
            .map((e) => Tab(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      e.name,
                      style: TextStyle(
                          color: AppColors.colors[ColorKeys.textPrimary],
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ))
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
    return PreferredSize(
      preferredSize: const Size.fromHeight(20),
      child: TabBar(
          isScrollable: true,
          controller: tabController,
          indicatorPadding: const EdgeInsets.only(bottom: 4),
          onTap: handleTapTabItem,
          tabs: tabItems),
    );
  }
}
