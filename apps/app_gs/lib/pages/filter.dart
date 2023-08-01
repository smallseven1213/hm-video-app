import 'package:app_gs/screens/filter/filter_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/filter_result_controller.dart';
import 'package:shared/controllers/filter_screen_controller.dart';
import 'package:shared/controllers/filter_short_result_controller.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';
import '../screens/filter/options.dart';
import '../screens/filter/video.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/list_no_more.dart';
import '../widgets/sliver_vod_grid.dart';
import '../widgets/tab_bar.dart';

final logger = Logger();

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  FilterScrollViewState createState() => FilterScrollViewState();
}

class FilterScrollViewState extends State<FilterPage>
    with SingleTickerProviderStateMixin {
  // DISPOSED SCROLL CONTROLLER
  late TabController _tabController;
  final ScrollController scrollController = ScrollController();
  final FilterScreenController filterScreenController =
      Get.find<FilterScreenController>();
  late FilterScreenResultController vodController;
  late FilterScreenShortResultController shortVodController;

  late Worker everWorker;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    everWorker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: '篩選',
        bottom:
            GSTabBar(tabs: const ['長視頻', '短視頻'], controller: _tabController),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [VideoFilterPage(), Container()],
      ),
    );
  }
}
