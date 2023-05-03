import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/actor_region_controller.dart';
import 'package:shared/controllers/actors_controller.dart';

import '../../widgets/tab_bar.dart';

class ActorsTabBar extends StatefulWidget {
  @override
  _ActorsTabBarState createState() => _ActorsTabBarState();
}

class _ActorsTabBarState extends State<ActorsTabBar>
    with TickerProviderStateMixin {
  TabController? _tabController;
  final actorsController = Get.put(ActorsController());
  final actorRegionController = Get.find<ActorRegionController>();

  // init
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 0, vsync: this);
    actorRegionController.regions.listen((regions) {
      _tabController?.dispose();
      _tabController = TabController(length: regions.length, vsync: this);
      _tabController?.addListener(() {
        actorsController.region.value =
            actorRegionController.regions[_tabController!.index].id;
      });
      setState(() {});
    });
  }

  // dispose
  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => GSTabBar(
          controller: _tabController,
          padding: const EdgeInsets.only(bottom: 0),
          tabs: actorRegionController.regions
              .where((e) => e.name != null)
              .map((e) => e.name!)
              .toList(),
        ));
  }
}
