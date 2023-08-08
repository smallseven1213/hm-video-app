import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/filter_screen_controller.dart';
import '../screens/filter/short.dart';
import '../screens/filter/video.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/tab_bar.dart';

final logger = Logger();

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
    super.dispose();
    _tabController.dispose();
    _tabController.animation!.removeListener(() {}); // 別忘了在 dispose 中移除監聽器
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: CustomAppBar(
          title: '篩選',
          bottom: filterScreenController.showTabBar.value
              ? GSTabBar(tabs: const ['長視頻', '短視頻'], controller: _tabController)
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
