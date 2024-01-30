import 'package:app_wl_cn1/widgets/custom_app_bar.dart';
import 'package:app_wl_cn1/widgets/tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/filter_screen_controller.dart';

import '../screens/filter/short.dart';
import '../screens/filter/video.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  FilterScrollViewState createState() => FilterScrollViewState();
}

class FilterScrollViewState extends State<FilterPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FilterScreenController filterScreenController =
      Get.find<FilterScreenController>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);

    // 监听tab滑动
    _tabController.animation!.addListener(() {
      if (_tabController.animation!.value % 1 != 0) {
        // 如果动画值不是整数，表示滑动正在进行中
        filterScreenController.handleOption(showTab: true, openOption: false);
      }
    });
  }

  @override
  void dispose() {
    _tabController.animation!.removeListener(() {}); // 别忘了在 dispose 中移除监听器
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: CustomAppBar(
          title: '筛选',
          bottom: filterScreenController.showTabBar.value
              ? TabBarWidget(
                  tabs: const ['长视频', '短视频'], controller: _tabController)
              : null,
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [VideoFilterPage(), ShortVideoFilterPage()],
        ),
      );
    });
  }
}
