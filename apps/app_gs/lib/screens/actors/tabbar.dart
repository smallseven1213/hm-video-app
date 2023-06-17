import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/actor_region_controller.dart';
import 'package:shared/controllers/actors_controller.dart';

import '../../widgets/tab_bar.dart';

class ActorsTabBar extends StatefulWidget {
  const ActorsTabBar({Key? key}) : super(key: key);
  @override
  ActorsTabBarState createState() => ActorsTabBarState();
}

class ActorsTabBarState extends State<ActorsTabBar>
    with TickerProviderStateMixin {
  TabController? _tabController;
  final actorsController = Get.find<ActorsController>();
  final actorRegionController = Get.find<ActorRegionController>();

  @override
  void initState() {
    super.initState();

    // Listener function
    void tabControllerListener() {
      if (_tabController?.indexIsChanging ?? false) {
        final index = _tabController!.index;
        if (index < actorRegionController.regions.length) {
          actorsController.setRegion(actorRegionController.regions[index].id);
        }
      }
    }

    // Initial creation of the TabController with the current length of regions.
    _tabController = TabController(
        length: actorRegionController.regions.value.length, vsync: this);

    // Adding listener to TabController to update the selected region.
    _tabController?.addListener(tabControllerListener);

    // Listen for changes in regions.
    actorRegionController.regions.listen((regions) {
      if (_tabController?.length != regions.length) {
        // If the length changes, create a new TabController with the new length.
        _tabController?.removeListener(
            tabControllerListener); // Remove listener from old controller.
        _tabController = TabController(length: regions.length, vsync: this);

        // Re-attach the listener to the new TabController.
        _tabController?.addListener(tabControllerListener);
      }
    });
  }

  // dispose
  @override
  void dispose() {
    actorsController.setRegion(actorRegionController.regions[0].id);
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => GSTabBar(
          controller: _tabController,
          tabs: actorRegionController.regions
              .where((e) => e.name != null)
              .map((e) => e.name!)
              .toList(),
          padding: const EdgeInsets.only(top: 15, bottom: 0),
        ));
  }
}
