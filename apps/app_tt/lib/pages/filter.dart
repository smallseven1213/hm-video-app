import 'package:app_tt/localization/i18n.dart';
import 'package:app_tt/widgets/my_app_bar.dart';
import 'package:app_tt/widgets/tt_tab_bar.dart';
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

    // 監聽tab滑動
    _tabController.animation!.addListener(() {
      if (_tabController.animation!.value % 1 != 0) {
        // 如果動畫值不是整數，表示滑動正在進行中
        filterScreenController.handleOption(showTab: true, openOption: false);
      }
    });
  }

  @override
  void dispose() {
    _tabController.animation!.removeListener(() {}); // 別忘了在 dispose 中移除監聽器
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: MyAppBar(
          title: I18n.filter,
          bottom: filterScreenController.showTabBar.value
              ? TTTabBar(
                  tabs: [I18n.longVideo, I18n.shortVideo],
                  controller: _tabController)
              : null,
        ),
        body: TabBarView(
          controller: _tabController,
          // physics: const NeverScrollableScrollPhysics(),
          children: const [VideoFilterPage(), ShortVideoFilterPage()],
        ),
      );
    });
  }
}
