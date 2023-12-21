import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/live_list_controller.dart';
import '../models/room.dart';

class LiveListProvider extends StatefulWidget {
  final Widget Function(List<Room> ads) child;
  const LiveListProvider({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  LiveListState createState() => LiveListState();
}

class LiveListState extends State<LiveListProvider> {
  final LiveListController controller = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => widget.child(controller.filteredRooms));
  }
}
